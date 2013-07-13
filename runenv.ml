let execv argv =
  flush stdout;
  flush stderr;
  let open Unix in
  try
    let argv_array = Array.of_list argv in
    let prog_path = List.hd argv in
    let child_pid = Unix.create_process prog_path argv_array stdin stdout stderr in
    match snd (waitpid [] child_pid) with
    | Unix.WEXITED code -> exit code
    | _ -> exit 127
  with Unix.Unix_error _ as ex ->
    let cmd = String.concat " " argv in
    failwith (Printexc.to_string ex ^ "\n... trying to exec: " ^ cmd)

let () =
  match Array.to_list Sys.argv with
  | [] -> failwith "No args passed to runenv!"
  | arg0::args ->
      let var = "zeroinstall-runenv-" ^ Filename.basename arg0 in
      let s =
        try Unix.getenv var
        with Not_found -> failwith ("Environment variable '" ^ var ^ "' not set!")
      in
      let open Yojson.Basic in
      let envargs = Util.convert_each Util.to_string (from_string s) in
      execv (envargs @ args)
