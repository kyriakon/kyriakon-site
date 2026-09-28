#!/bin/sh
# Finishes the restore template after OpenBSD's installer has run.
#
# The installer's sshd step writes "PermitRootLogin no", so a fresh install
# refuses root over ssh no matter what is in authorized_keys. The weekly standup
# reaches its throwaway box as root by key, so this has to be put right once, in
# the template, before the snapshot that every throwaway boots from.
#
# Run on the installed box, as root:
#   ftp -o /tmp/t https://kyriakon.net/template-setup.sh && sh /tmp/t
#
# Safe to run twice. Nothing secret is in this file: the key below is a public
# half, and root's password is left alone deliberately, so the console still
# works until it is cleared by hand.

set -eu

KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFvWcMN1mB46y9E9diUw+c9S4AP0S7fYCvvwa1NyKzgj oliver@kyriakon.net'

[ "$(id -u)" -eq 0 ] || { echo "run this as root" >&2; exit 1; }
[ -d /etc/ssh ] || { echo "not an installed system" >&2; exit 1; }

echo "== root by key, not by password =="
if grep -q '^[[:space:]]*PermitRootLogin[[:space:]]' /etc/ssh/sshd_config; then
	sed -i 's/^[[:space:]]*PermitRootLogin[[:space:]].*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
else
	# Absent entirely. The compiled default is already prohibit-password, but write
	# it out so the file says what is actually in force, and so a config that lost
	# the line cannot look like a config that never had one.
	echo 'PermitRootLogin prohibit-password' >> /etc/ssh/sshd_config
fi
grep -q '^PermitRootLogin prohibit-password' /etc/ssh/sshd_config || {
	echo "could not set PermitRootLogin" >&2; exit 1; }
printf 'file says:    %s\n' "$(grep '^PermitRootLogin' /etc/ssh/sshd_config)"
printf 'sshd -T says: %s\n' "$(sshd -T 2>/dev/null | grep -i '^permitrootlogin')"
printf 'file size:    %s bytes, %s lines\n' "$(wc -c < /etc/ssh/sshd_config | tr -d ' ')" "$(grep -c . /etc/ssh/sshd_config | tr -d ' ')"

echo "== the key, where sshd reads it =="
# The installer sets AuthorizedKeysFile to .ssh/authorized_keys, so this is the
# one place that matters, and both the file and its directory must not be
# group or world writable or sshd ignores them.
mkdir -p /root/.ssh
chmod 700 /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
grep -qF "$KEY" /root/.ssh/authorized_keys || echo "$KEY" >> /root/.ssh/authorized_keys
printf 'authorized_keys holds %s line(s)\n' "$(wc -l < /root/.ssh/authorized_keys | tr -d ' ')"

echo "== restarting sshd, which reads its config only at startup =="
# sshd holds sshd_config in memory from the moment it starts, so editing the file
# changes nothing until it re-reads. On this template that was the difference
# between a key being accepted and the login being allowed, and it looked exactly
# like the edit had never happened. A restart is unambiguous; a HUP is the
# fallback if rcctl does not know the service.
if ! rcctl restart sshd; then
	kill -HUP "$(cat /var/run/sshd.pid)" && echo "rcctl could not restart it; sent SIGHUP instead"
fi
sleep 1
printf 'sshd -T says: %s\n' "$(sshd -T 2>/dev/null | grep -i '^permitrootlogin')"
echo "config now: $(grep '^PermitRootLogin' /etc/ssh/sshd_config)"
ls -la /root/.ssh/ | sed -n '1,5p'

echo "== what the restore test needs =="
pkg_add restic jq git || true
for p in restic jq git; do
	printf '  %-8s ' "$p"; command -v "$p" >/dev/null 2>&1 && echo present || echo MISSING
done

echo "== the test scripts, from the public repo =="
mkdir -p /root/bin
for f in lib.sh restore-test.sh; do
	ftp -o "/root/bin/$f" "https://raw.githubusercontent.com/kyriakon/kyriakon-infra/main/scripts/$f"
	chmod 0755 "/root/bin/$f"
done
ls -l /root/bin/

echo
echo "done."
echo "Before snapshotting, confirm: ssh root@<this box> works with the key, then lock"
echo "root's password with "usermod -p '*' root" if one was set, so no throwaway inherits"
echo "a console login. OpenBSD's passwd has no -d; keys keep working with a locked password."
