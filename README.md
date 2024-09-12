# Chess

Valid Move
- Space is available
- There are no collisions
- Move doesnt put king in check

Not moving into check
- White piece tries to move into a space that puts the white king in check
- Iterates over all pieces of opposite color
- Check if next move of any piece coincides with position of white king
- Check if any collisions
- Invalid move if no collisions
- Messed around with Marshal.load(Marshal.dump(@piece_positions)) to save the piece positions before the move into check
- Solution was to swap the curr_pos and move_pos so the piece moves back to original pos if it moves into check

Check
- Currently checks if piece that just moved has a next move that coincides with position of black king
- Needs to check if any pieces next move coincides with position of black king

Is not moving into check and check the same function??

Rooks

Seems to check first rook and returns a collision without checking other rook - OK

NEXT ISSUE:

SEEMS TO BE SPECIFIC WITH FROM 'CHECK'

THINGS ARE HAPPENING THAT ARENT DISPLAYED
KNIGHT BLOCKING CHECK ISN'T SHOWN ON BOARD
NOT GOING TO NEXT PLAYERS TURN
Move not ending after CHECK
ROOKS CAN REPLACE KINGS POSITION - OK
KNIGHTS CANT MOVE AFTER CHECK
QUEEN CAN CAPTURE WITHOUT MOVING TO POSITION

WHAT IS HAPPENING IN CODE

QUEEN MOVES TO A CHECK POSITION WITH A PAWN BLOCKING
BLACK KNIGHT CANT MOVE, CHECK KING == TRUE, CHECK!

Black Queen blocked by bishop for a check
White moves
Black Queen still blocked for a check
Check is shown
True @check black king
Game breaks

White bishop checks black king
No check 
black tries to move while still in check
black king check TRUE
Check!
knight can move
game breaks

@board.board_update
this is updating all the invalid move positions

Capturing a piece means both pieces occupy same spot?

Piece attempts to take piece moving into check
piece is removed, knight moves backn