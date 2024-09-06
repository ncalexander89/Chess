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

Move not ending after capture

