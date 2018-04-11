open State
 
type input = {
    left_mouse_down:bool
}

type properties = {
    num_towers:int
}

exception Init_Failure of string

let init_game prop : state = 
  print_endline "Starting game!";
  Graphics.open_graph "";
  {
    towers = [|{id=0;pos=(100.,100.);twr_sprite=[];twr_troops=10;twr_team=Player}|];
    num_towers = 2;
    player_score = 1;
    enemy_score = 1;
    movements = [];
    player_mana = 100;
    enemy_mana = 100
  }

let get_input () = 
  {left_mouse_down=Graphics.button_down ()}

let update ste inpt = 
  if inpt.left_mouse_down then (ste,false) else ste,true

let render ste = 
  Graphics.auto_synchronize false;
  Graphics.clear_graph ();
  (* Render *)
  Graphics.auto_synchronize true;
  ()

let rec game_loop ste run =
  if not run then ste 
  else begin
    let (new_ste, should_run) = update ste (get_input ()) in
    render ste;
    Unix.sleepf 0.01;
    game_loop new_ste should_run;
  end
  
let close_game ste = 
  Graphics.close_graph ();
  print_endline "Closing Game!";

;;

(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
let main () =
  let prop = {num_towers=5} in
  let init_state = init_game prop in
  let end_state = game_loop init_state true in
  close_game end_state;
;;

let () = main ()