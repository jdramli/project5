# project5{

Game title: BUG BUSTER\
\
Project 5 Multiple objects and collisions with better formatted code and use of classes in MVC format.\
\
The goal of this project for starters is to make a cleaner and better version of a game with collisions\
and contacts.  Adding classes for a cleaner and more modifiable code-base and adding in arrays or \
better use of built-in SpriteKit methods for handling groups of objects to keep things smooth and efficient is the goal.\
\
Overall, while the code is not well parsed into separate files, there are sections identified with comments.  Significant progress in understanding and execution of some structural game concepts such as:\
-- Detailed implementation of multiple contact and collision detection for 4 different SKPhysics bodies.  \
-- Changing game features/counters on certain contacts\
--Implementation of a with different game timer separate from update  function\
--Implementation of UIBezier Paths to change object routes and motions.\
\
\
Progress log:\
\
10/30: Created repository.\
	Re-established the ability to programmatically draw a sprite shape object\
	Created a \'93Bullet\'94 class file\
	Added this README file\
\
11/1:  Added ability to copy the "bullet" object and make it appear on position (changed color to green to show copy).\
	Added a hero object that appears at 0,0, the bottom left corner of the screen (yellow rectangle for now)\
	Added a pathing section of code to allow the green copied bullet to move along toward a destination.\
	Encountered major debugging issue where the frame of reference of an SKShapeNode starts at 0,0 BOTTOM LEFT but orienting the bullet copy positions start at 0,0 starting in the MIDDLE OF THE SCREEN.  This could take some time to figure out how to change the frame of references to match up.\
\
11/2: Added the potential for a bullet object as an SKSpriteNode\
	Manually found x and y adjustments to the offset of "player"!.position or "hero"!.position to make the "bullet" come off from near the edge where the shooter is drawn\
	Created a moveTo function to instantly move SKNodes to a desired location instantly.\
\
11/3:  Fixed the bug from 11/2 where bullet needed a manual offset.  Instead, bullet comes directly out of playersprite center by calling a start position of player!.anchorPoint.  \
	Player moves toward cursor click\
	Added an "enemy" SKSpriteNode object that can adopt many picture-type files as a texture\
	Created an enemy spawn on timer method that spawns an enemy every 1 second.\
	Created a path to move that enemy toward the last known player position when the enemy is created.\
	Next major steps are to get good details in collision detection and start to generate win and player-defeat conditions\
\
11/4: Added multiple view controllers.  Start Screen and potential "HighScore" screen\
	Verified unwind segues work for all 4 buttons implemented on the GameViewController and LeaderBoardViewController\
	Added physics bodies to the player and enemy sprites\
	Added physics bodies to bullet sprites\
\
11/5:  Added contact detection between bullet and enemy sprites.\
	Contact now removes enemy from screen when hitting bullet\
\
11/6: Added enemy kill counter.  \
	Bullet disappears on enemy contact.\
	Looking to add a power-up sprite\
\
11/7: Added Singleton-powered Leaderboard outline (doesn't update yet)\
	Experimenting with enemy and player contact detection/scenarios\
	Encountered major bugs in contact detection with hero\
	Added a speed multiplier option (commented code out for now) that increases enemy speed as kill_count rises\
	Added a red-ball node that spawns and zig zags.  It is the basis for a power-up node that may alter player weapons.\
\
11/8: Fixed contact detection with hero\
	Fixed contact detection with upgrade nodes\
	Made the Leaderboard table update on contact between bug and hero and reset kill counter\
	Experimenting with ideas for what power-up upgrades will do\
\
11/9: Major shift in code from copy of bullet to re-creation of bullet on touchdown allows for bullet resize\
	Ensured that all contacts and upgrades go up to a max level of 10 and increase bullet-size by 10 levels (increase radius by 1 each time)\
	Contact detection and upgrades and highscores still work after bullet resize\
	Experimented with "scale" and resize of copy but these were not effective.  Copying the creation code to touch-down seems to work for now\
	Added another label node to show the upgrade level (number of red balls that the player contacted)\
	Considering splitting off the game timer to reduce speed of power up node appearance (the current rate is great for testing though)\
\
11/10: Made more enemies spawn as kill_count rises. (Did not adjust their positions yet, so they come in a giant block)\
	Increased enemy speed as well as kill count rises!\
	\
	Changed enemy start location on copy as speed increases.  Makes more of an enemy spread.\
	Player bullet increases in size as upgrades are contacted! \
	\
\
Optional things that are next to add are: \
- Busted Bug animation.\
-A "pause" on contact with enemy and player, and a shift to a "restart" button or screen.\
-Maybe a second game scene with larger enemies.\
\
\
	\
\
}
