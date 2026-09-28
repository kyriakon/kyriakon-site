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
sed -i 's/^[[:space:]]*PermitRootLogin[[:space:]].*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
grep -q '^PermitRootLogin prohibit-password' /etc/ssh/sshd_config || {
	echo "could not set PermitRootLogin" >&2; exit 1; }
grep '^PermitRootLogin' /etc/ssh/sshd_config

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

echo "== reloading sshd, which reads its config only at startup =="
# Without this the file is correct and the running daemon still refuses root, so
# ssh fails with the same message as if the edit had never happened. sshd
# re-executes on SIGHUP, which re-reads the config without dropping connections.
if [ -f /var/run/sshd.pid ]; then
	kill -HUP "$(cat /var/run/sshd.pid)" && echo "sent SIGHUP to sshd"
else
	rcctl restart sshd && echo "restarted sshd"
fi
sleep 1
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
echo "Before snapshotting, confirm: ssh root@<this box> works with the key, then clear"
echo "root's password with 'passwd -d root' if one was set, so no throwaway inherits it."
