//"SPDX-License-Identifier:UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract BlackJack {
    //////////////////////////////////////////
    //Configurable
    //////////////////////////////////////////
    uint initial_balance = 10000; //TODO: configurable
    
    //////////////////////////////////////////
    //Errors
    //////////////////////////////////////////
    string not_enough_money = "Not enough money!";
    string account_not_exist = "Account does not exist!";
    string please_bet = "please_bet";
    string bust = "you have already busted!";
    string already_bet = "you have already made the bet!";
    string game_not_finish = "game is not finished yet!";
    string game_finish = "game is already finished!";

    //////////////////////////////////////////
    //Struct
    //////////////////////////////////////////
    struct Account{
        bool exist;
        uint balance;
        Game game; 
    }
    
    struct Game{
        uint bet;
        uint dealer_hidden_card;
        uint[] dealer_showed_cards;
        uint[] player_cards;
        bool is_finish;
    }
    
    //Mapping
    mapping (address => Account) accounts;
    
    //////////////////////////////////////////
    //Function Public, Main Roadmap
    //////////////////////////////////////////
    function get_balance() public returns(uint){ // login/create account
        if (is_account_exist(msg.sender)) {
            return accounts[msg.sender].balance;
        }
        else {
            accounts[msg.sender].exist = true;
            accounts[msg.sender].balance = initial_balance;
            return accounts[msg.sender].balance;
        }
    }

    function initialize_game() public {
        require(accounts[msg.sender].game.is_finish, game_not_finish);
        accounts[msg.sender].game.bet = 0; //also a way to judge if game has started, if bet = 0 means game is not started
        accounts[msg.sender].game.dealer_hidden_card = 99; //means no card
        delete accounts[msg.sender].game.dealer_showed_cards;
        delete accounts[msg.sender].game.player_cards;
        accounts[msg.sender].game.is_finish = false;
    }
    
    function get_game() public view returns(Game memory) { //get current information of the game
        require(is_account_exist(msg.sender), account_not_exist);
        return accounts[msg.sender].game;
    }
    
    function bet(uint value) public {//player makes his bet, initial cards delievered
        require(is_account_exist(msg.sender), account_not_exist);
        require(accounts[msg.sender].balance >= value, not_enough_money);
        require(accounts[msg.sender].game.bet == 0, already_bet);
        accounts[msg.sender].balance -= value;
        accounts[msg.sender].game.bet += value;

        //send initial cards
        uint id = rand(52);
        accounts[msg.sender].game.dealer_hidden_card = id;
        new_card(true); //send new card for dealer
        new_card(false);//send new card for player
        new_card(false);
    }

    function hit() public {
        require(is_account_exist(msg.sender), account_not_exist);
        require(accounts[msg.sender].game.bet!=0, please_bet);
        require(get_player_score()<=21, bust);
        require(!accounts[msg.sender].game.is_finish, game_finish);
        new_card(false);//send new card for player

        if(get_player_score()>21){ // player bust
            accounts[msg.sender].game.is_finish = true;
            get_result();
        }
    }

    function stand() public {// player stands, dealer keeps taking cards until soft 17
        require(is_account_exist(msg.sender), account_not_exist);
        require(accounts[msg.sender].game.bet!=0, please_bet);
        require(get_player_score()<=21, bust);
        require(!accounts[msg.sender].game.is_finish, game_finish);

        while(get_dealer_score()<17){
            new_card(true);//send new card for dealer
        }
        accounts[msg.sender].game.is_finish = true;
        get_result();
    }

    function get_result() public returns (uint){//1:player wins; 2:dealer wins; 3:tie
        require(is_account_exist(msg.sender), account_not_exist);
        require(accounts[msg.sender].game.bet!=0, please_bet);
        require(accounts[msg.sender].game.is_finish, game_not_finish);

        uint player = get_player_score();
        uint dealer = get_dealer_score();

        if(player>21){//player bust
            return 2;
        }
        else if(dealer>21){//dealer bust
            accounts[msg.sender].balance += 2*accounts[msg.sender].game.bet;
            return 1;
        }
        else if(player>dealer){
            return 1;
        }
        else if(player<dealer){
            accounts[msg.sender].balance += 2*accounts[msg.sender].game.bet;
            return 2;
        }
        else {
            accounts[msg.sender].balance += accounts[msg.sender].game.bet;
            return 3;
        }
    }

    //////////////////////////////////////////
    //Function Public, Get Key Information
    //////////////////////////////////////////
    function get_player_score() public view returns(uint){
        uint[] memory cards = accounts[msg.sender].game.player_cards;
        uint score = 0;
        uint num_ace = 0;

        for(uint i = 0; i < cards.length; i++) {
            score += id_to_val(cards[i]);
            if (id_to_val(cards[i])==11) num_ace++;
        }

        //if bust but have Ace, score -10
        while(score>21&&num_ace>0){
            score -= 10;
            num_ace --;
        }

        return score;
    }

    function get_dealer_score() public view returns(uint){
        uint[] memory cards;
        uint score = 0;
        uint num_ace = 0;

        cards = accounts[msg.sender].game.dealer_showed_cards;
        for(uint i = 0; i < cards.length; i++) {
            score += id_to_val(cards[i]);
            if (id_to_val(cards[i])==11) num_ace++;
        }
        uint hidden_card = accounts[msg.sender].game.dealer_hidden_card;
        score += id_to_val(hidden_card);
        if (id_to_val(hidden_card)==11) num_ace++;

        //if bust but have Ace, score -10
        while(score>21&&num_ace>0){
            score -= 10;
            num_ace --;
        }

        return score;
    }
    
    //////////////////////////////////////////
    //Function Private
    //////////////////////////////////////////
    function is_account_exist(address _addr) private view returns(bool){
        return accounts[_addr].exist;
    }

    function rand(uint256 _length) private view returns(uint256) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
        return random%_length;
    }

    function new_card(bool is_dealer) private {
        uint id = rand(52);
        if (is_dealer){
            accounts[msg.sender].game.dealer_showed_cards.push(id);
        }
        else{
            accounts[msg.sender].game.player_cards.push(id);
        }
    }

    function id_to_val(uint card_id) pure private returns (uint){
        require(card_id>=0&&card_id<=51, "invalid input!");
        uint card_val = card_id%13+1;
        uint val;
        if(card_val==1) val = 11;
        else if(card_val==11||card_val==12||card_val==13) val = 10;
        else val = card_val;
        return val;
    }


}
