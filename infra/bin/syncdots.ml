let home = Sys.getenv "HOME"

let resolve_dots (dot : string) =
  let is_symlink (stat : Unix.stats) = stat.Unix.st_kind = Unix.S_LNK in
  let fullpath = Filename.concat home dot in
  let stat = Unix.lstat fullpath in
  if is_symlink stat then Unix.readlink fullpath else fullpath

let servers =
  if Array.length Sys.argv > 1 then Sys.argv
  else
    [|
      (* 5950x *)
      "shinx";
      "luxio";
      "manectric";
      "minun";
      (* Unmatched *)
      "larvesta";
      "reshiram";
      "incineroar";
      "talonflame";
      "volcanion";
      "torracat";
      "oricorio";
    |]

let dotfiles =
  [ ".vimrc"; ".bashrc"; ".tmux.conf" ]
  |> List.map (fun dot -> resolve_dots dot)

let wait_process proc =
  let _, status = Unix.process_full_pid proc |> Unix.waitpid [] in
  match status with
  | Unix.WEXITED 0 -> Ok ()
  | _ ->
      let _, _, stderr = proc in
      Error (In_channel.input_all stderr)

(* Perform a `rsync -azvhP $files $remote:~/` command execution *)
let rsync ~(remote : string) ~(files : string list) =
  let remote_target = Printf.sprintf "%s:~/" remote in
  let rsync_arg =
    ("rsync" :: "-azvhP" :: files) @ [ remote_target ] |> Array.of_list
  in
  let handle_rsync proc =
    match wait_process proc with
    | Ok () -> Format.printf "==> %s DONE\n" remote
    | Error err ->
        Format.printf "Fail to sync file to %s\n" remote;
        Format.printf "--------------- stderr --------------\n";
        Format.printf "%s\n\n" err
  in
  let proc =
    Unix.open_process_args_full "rsync" rsync_arg (Unix.environment ())
  in
  Out_channel.flush_all ();
  handle_rsync proc

let () = servers |> Array.iter (fun srv -> rsync ~remote:srv ~files:dotfiles)
