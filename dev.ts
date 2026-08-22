import { watch } from "node:fs";

// dev.ts — dev server: static files + Tailwind rebuild + live reload.
// Usage: bun dev.ts

const PORT = 8017;
let version = 0;

const MIME: Record<string, string> = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript",
  ".png": "image/png",
  ".svg": "image/svg+xml",
  ".ico": "image/x-icon",
  ".webp": "image/webp",
};

const ext = (p: string) => {
  const i = p.lastIndexOf(".");
  return i < 0 ? "" : p.slice(i);
};

const RELOAD =
  `<script>(async()=>{const v=await fetch("/__version").then(r=>r.text());setInterval(async()=>{if(await fetch("/__version").then(r=>r.text())!==v)location.reload()},700)})()</script>`;

async function rebuild() {
  const proc = Bun.spawn(["tailwindcss", "-i", "src/input.css", "-o", "assets/main.css", "--minify"]);
  const code = await proc.exited;
  if (code !== 0) console.error(`tailwindcss exited ${code}`);
  else version++;
}

const server = Bun.serve({
  port: PORT,
  async fetch(req) {
    const url = new URL(req.url);

    if (url.pathname === "/__version") return new Response(String(version));

    let path = url.pathname === "/" ? "index.html" : url.pathname.slice(1);
    if (path.endsWith("/")) path += "index.html";

    const file = Bun.file(path);
    if (!(await file.exists())) return new Response("Not found", { status: 404 });

    if (ext(path) === ".html") {
      const html = (await file.text()).replace("</body>", RELOAD + "</body>");
      return new Response(html, { headers: { "content-type": "text/html; charset=utf-8" } });
    }

    return new Response(file, { headers: { "content-type": MIME[ext(path)] ?? "application/octet-stream" } });
  },
});

// Content files that affect the compiled CSS — add new pages here.
for (const f of ["src/input.css", "index.html", "hosting/index.html", "press/index.html", "kleio/index.html"]) {
  watch(f, () => rebuild());
}

await rebuild();
console.log(`Kyriakon dev server → http://localhost:${server.port}`);
