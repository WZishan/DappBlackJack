// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./ConvertLib.sol";

contract BlackJack {
  
    /*
    *   Dealer
    *   Only one dealer at a time
    */  

    mapping(address => Dealer) public dealer;        // address = key, Player is value

    struct Dealer {
        uint[] gameIds;
        uint card1;
        uint card2;
    }
    /*
    *   Player
    *   Only one player at a time
    */
    
    mapping(address => Player) public players;        // address = key, Player is value

    struct Player {
        bytes32 name;
        uint[] gameIds;
        uint balance;
        uint card1;
        uint card2;
    }

    /*
    *   Games
    *   One player may have many games
    */

    uint counter = 0;
    mapping(uint => Game) public games;

    //suppose to have ? game states
    enum GameState {}

    struct Game {
        uint gameId;
        address ownerAddr;
        GameState state;
        uint moveCounter;
        address playerAddr;
        address winnerAddr;
    }

    //init game
    constructor() public {
    
    }

    // during play functions
    function playMove(uint gameId, address player, address dealer) public {

    }

    //player hit
    function hit(uint gameId, address player) public {

    }

    //player stand
    function stand(uint gameId, address player) public {

    }

}
