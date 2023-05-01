import { join } from "https://deno.land/std@0.178.0/path/mod.ts";

const home = Deno.env.get("HOME");
if (home === undefined) {
  console.error(
    "No $HOME variable found, this script only works on Linux environment.",
  );
  Deno.exit(1);
}

const from_home = (...path: string[]) => {
  return join(home, ...path);
};

const pending_files = [
  from_home(".vimrc"),
  from_home(".bashrc"),
  from_home(".tmux.conf"),
];

const servers = Deno.args.length > 0 ? Deno.args : [
  // 5950x
  "shinx",
  "luxio",
  "manectric",
  "minun",

  // unmatched stable
  "larvesta",
  "reshiram",
  "incineroar",
  "talonflame",

  // unmatched unstable
  "volcanion",
  "torracat",
  "oricorio",
];

const rsync = async (remote: string, ...path: string[]) => {
  const handle = new Deno.Command("rsync", {
    args: [
      "-azvhP",
      ...path,
      `${remote}:~/`
    ]
  }).spawn();
  const status = await handle.status;
  if (!status.success) {
    console.error(`fail to sync file to ${remote}`)
  }
}

for (const srv of servers) {
  console.log(`==> Sending file to ${srv}`)
  rsync(srv, ...pending_files)
}
