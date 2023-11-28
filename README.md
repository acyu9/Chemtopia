# Chemtopia
This game is developed for high school Chemistry students to practice the 5 types of chemical reactions. It consists of RPG and card battle components and is made with the Godot 4.1 engine.

## Cards
All the relevant scenes and code for the card battle system. The card_base scene has script for the design of the individual card. The player_hand scene sets up the cards, including fan animation and drawing card. The deck scene has the script for the deck that randomly selects from the dictionary of cards for that chemical reaction. Lastly, the game_board scene holds all the pieces together and includes scripts for opponent move and the whole game mechanism.

## Data
This folder contains dictionaries for the cards and the 5 types of chemical reactions. The cards dictionary has the chemical formula, name, category, information, and description. The reaction types dictionaries have the reactants, products, and coefficient of the balanced products. These are json files converted from Google Sheets.

## Dialogues
This folder contains the dialogues in the game. It also holds the scene for the dialogue bubble. See the Credit section for the Dialogue Manager add-on.

## Globals
Global scripts and scenes for the game, such as transition animations from scene to scene. These can be accessed anywhere in the game.

## Graphics
Holds the sprites for the game. See the Credit section for more information.

## Music
Holds the music files for the game. See the Credit section for more information.

## Scenes
This folder contains the scenes for the levels (player house, town, diner, and yard), the characters, and other features such as chemtopia. 

## Credits
Special thanks to all the artists and musicians.  
NPCs by Elthen: https://elthen.itch.io/   
Player, indoors, & outdoor by Lime Zu: https://limezu.itch.io/  
Diner by Gif: https://gif-superretroworld.itch.io/interior-pack   
Card template by Piposcpatz: https://piposchpatz.itch.io/card-frame-template   
UI by LoudEyes: https://loudeyes.itch.io/paper-ui-pack-for-games  
Godot 4 plugin by Nathan Hoad:   https://github.com/nathanhoad/godot_dialogue_manager   
Cards palette by Conker: https://lospec.com/palette-list/pollen8  
Music by SubspaceAudio: https://juhanijunkala.com/   
