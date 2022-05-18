<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
      <div class="card_box" v-for="(item, index) in dealer_arr" :key="index"
        :class="{ 'no_see': no_see_bool && index == dealer_arr.length - finish }">
        <p v-if="no_see_bool && index == dealer_arr.length - finish"></p>
        <p v-else>{{ item }}</p>
      </div>

      <div class="current_score">
        <div>
          current points:
        </div>
        <div class="score_num">{{ dealer_score }}</div>
      </div>
    </div>


      <div>
        <el-button class="click_btn" type="primary" plain @click="hit">HIT</el-button>
      </div>
      <div>
        <el-button class="click_btn" type="success" plain @click="stand">STAND</el-button>
      </div>
      <div>
        <el-button class="click_btn" type="success" plain @click="end">END</el-button>
      </div>

    <div class="player_box user_box">
    <div class="money_area">
        <div class="money">
          money:{{ balance }}
          <el-button type="primary" plain @click="add_money">add</el-button>
        </div>
        <div class="money">
          bet:{{ bet_num }}
          <el-button type="primary" plain @click="open">bet</el-button>
        </div>
      </div>
      <div class="card_area">
        <div class="card_box" v-for="(item, index) in player_arr" :key="index">
          <p>{{ item }}</p>
        </div>
        <div class="current_score">
          <div>
            current points:
          </div>
          <div class="score_num">{{ player_score }}</div>
        </div>
      </div>
    </div>
    <div class="bust_box" :class="{ 'dealer_win': dealer_win_bool, 'player_win': player_win_bool , 'even':even_bool}">
      {{get_result}}
    </div>
  </div>

</template>

<script>
import Vue from 'vue';
import Web3 from "web3";
import { setTimeout } from "timers";

export default {
  name: "match",
  
  data() {
    return {
      operate_show: false,
      no_see_bool: true,
      dealer_arr: [],
      player_arr: [],
      dealer_win_bool: false,
      player_win_bool: false,
      even_bool: false,
      balance: 0,
      bet_num: 0,
      stand_num: 0,
      dealer_score: 0,
      player_score: 0,
      add_balance: '',
      add_bet: 0,
      game_result: "",
      finish:1,
      result:0
    };
  },
  methods: {
      async transferCard(x){
      let y =0
      y= x % 13 + 1
      let stry= '' 
      if (y == 1){
        stry = 'A'
      }else if (y==11){
        stry = 'J'
      }else if (y==12){
        stry = 'Q'
      }else if (y==13){
        stry = 'K'
      }else{
        stry = String(y)
      }
      console.log("stry",x,y,stry)
      return stry
      },
      async get_game() {
      //let result = await get_game().tuple
      //this.stand_num = this.stand_num + 1
      //下注金额
      //let bet = result[0]
      // 庄家隐藏牌
      //let dealer_hidden_card = result[1]
      // 庄家牌组
      //let dealer_card = result.slice(2, this.stand_num)
      //this.dealer_arr = [...dealer_card, ...dealer_hidden_card]
      // 玩家牌组
      //let player_card = await this.contract.methods.get_balance().call({ from: this.account })
      //this.player_arr = player_card
      // 是否结束
      //let game_result = result[result.length - 1]

      let game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})
      this.stand_num = this.stand_num + 1
      let bet = game.bet

      console.log("this game",this.account, game, bet)

      let dealer_hidden_card = game.dealer_hidden_card
      let dealer_card = game.dealer_showed_cards
      this.dealer_arr = []
      for(var i = 0;i<dealer_card.length;i++)
      {
          let promisex=this.transferCard(parseInt(dealer_card[i]))
          promisex.then(value => {

            this.dealer_arr.push(value);
            console.log("strx",value,promisex);

          })
          //this.dealer_arr.push(strx)
          //console.log("strx",strx)
      }
      let promisex=this.transferCard(parseInt(dealer_hidden_card))
          promisex.then(value => {

            this.dealer_arr.push(value);
            console.log("dealer_hidden_card",value,promisex);

          })

      console.log("dealer_card",dealer_card,dealer_hidden_card,String(dealer_hidden_card))

      //this.dealer_arr = Object.assign([],dealer_card)
      //this.dealer_arr.push(this.transferCard(dealer_hidden_card))
      console.log("dealer_arr get game",this.dealer_arr,dealer_card,dealer_hidden_card)


      let player_cards = game.player_cards
      this.player_arr = []
      for(var i = 0;i<player_cards.length;i++)
      {
          let promiseplayer=this.transferCard(parseInt(player_cards[i]))
          promiseplayer.then(value1 => {

            this.player_arr.push(value1);
            console.log("promiseplayer",value1,promiseplayer);

          })
          //this.dealer_arr.push(strx)
          //console.log("strx",strx)
      }



      console.log("player_arr get game",this.player_arr,player_cards)
      this.game_result =  game.is_finish

    },
    

    async get_result() {
      let result = await this.contract.methods.get_result().call({ from: this.account})
      console.log("get_result",result)
      if (result == 1) {
        // player win
        this.player_win_bool = true
        this.dealer_win_bool = false
        this.get_result = "You Win!"
      } else if (result == 2) {
        // dealer win
        this.player_win_bool = false
        this.dealer_win_bool = true
        this.get_result = "You lost!"
      } else {
        this.player_win_bool = false
        this.dealer_win_bool = false
        this.even_bool = true
        this.get_result = "Even!"
      }
      return parseInt(result)
    },


    async add_money() {

      
      await this.$prompt(
        `Please enter how much you want to charge`,
        "message",
        {
          confirmButtonText: "confirm",
          showClose: false,
          showCancelButton: false,
          closeOnClickModal: false,
          closeOnPressEscape: false,
          closeOnHashChange: false,
        }
      )
        .then(({ value }) => {
          
          // 充值确认之后的调用
          this.add_balance = String(value)
          console.log("add_balance0",this.add_balance)
          })
     
      const gasCharge = await this.contract.methods
                .charge_game_coins().estimateGas({ from: this.account }).catch(err => {console.error('error charge_game_coins ' + err);});
      console.log("gasCharge", gasCharge)
      let prenum = '0.00000000000000'
      let chargeStr = prenum + this.add_balance
      console.log("chargeStr", chargeStr)
      await this.contract.methods.charge_game_coins().send({from: this.account, value: Web3.utils.toWei(chargeStr),gas: 50000000})
      .catch(err => {console.error('error charge_game_coins ' + err);})
      console.log("add_balance00",this.add_balance)

      let has = await this.contract.methods.get_balance().call({ from: this.account })
      .catch(err => {
        console.error('error get_balance ' + err);
      })
      console.log("balance before charge", has, this.balance)
      this.balance = has
      console.log("balance after charge", has, this.balance)

      let game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})

      console.log("this game after charge", game)
        





    },
    async open() {
      let max_num = this.balance;
      console.log("max_num", max_num, this.balance)


      console.log("bet_num",this.bet_num)

      let gasBet = await this.contract.methods
              .bet(this.bet_num).estimateGas({ from: this.account });
      console.log("gasBet", gasBet)

      await this.$prompt(
        `Please enter your bet（you have ${max_num} now）`,
        "message",
        {
          confirmButtonText: "confirm",
          showClose: false,
          showCancelButton: false,
          closeOnClickModal: false,
          closeOnPressEscape: false,
          closeOnHashChange: false,
          inputValidator: (value) => {
            //let RegExp = /(^[\-0-9][0-9]*(.[0-9]+)?)$/;
            //console.log("RegExp",RegExp),RegExp.test(value) &&
            console.log("value,max",value,this.balance)
            return value <= parseInt(this.balance);
          },
          inputErrorMessage: "Invalid Number",
        }
      )
        .then(({ value }) => {
          //下注，使用bet函数
          this.bet_num = value
          console.log("betnum1",this.bet_num,this.account)

        })
        await this.contract.methods.bet(this.bet_num).send({from: this.account,gas:100000000}).catch(err => {
        console.error('error bet ' + err);})

        let game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})

        console.log("this game after bet", game)

        await this.get_game()
        
        console.log("bet get_game2",)

        this.get_player_score()

        let has = await this.contract.methods.get_balance().call({ from: this.account })
        .catch(err => {
          console.error('error get_balance ' + err);
        })
        this.balance = has
        console.log("balance after bet", has, this.balance)

        //this.get_game()

    },

    async stand() {

      const gasStand = await this.contract.methods
               .stand().estimateGas({ from: this.account }).catch(err => {console.error('error charge_gasHit ' + err);});
      console.log("gasStand", gasStand)

      //await this.contract.methods.stand().call({from: this.account })
      await this.contract.methods.stand().send({from: this.account, gas:100000000 })  
      .catch(err => {
        console.error('error stand ' + err);})
      this.finish=0
      let game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})

      console.log("this game after stand", game)

      //await this.contract.methods.get_result().send({ from: this.account,gas:100000000}).catch(err => {
      //  console.error('error get_result ' + err);})
      //console.log("change result")



      let res = await this.get_result()
      this.get_player_score()
      this.get_dealer_score()
      let has = await this.contract.methods.get_balance().call({ from: this.account })

      .catch(err => {
        console.error('error get_balance ' + err);
      })
      this.balance = has
      console.log("balance after stand", has, this.balance)
      
      await this.get_game()
      console.log("finishe this game",this.get_game)

      //await wait(10000);
      console.log("Waited 10s");
      this.result = res

    },
    async end(){
      if (this.result == 1) {
        this.$router
                  .push({
                      path: "/win",
                  })
                  .catch((err) => {
                      err;
                  });
      }
      else{
        this.$router
                .push({
                    path: "/game_over",
                })
                .catch((err) => {
                    err;
                });
      }
    },

    async hit() {

      let game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})
      await this.get_game()
      console.log("this game before hit", game)


      const gasHit = await this.contract.methods
                .hit().estimateGas({ from: this.account }).catch(err => {console.error('error charge_gasHit ' + err);});
      console.log("gasHit", gasHit)

      //await this.contract.methods.hit().send({from: this.account,gas:gasHit })
      await this.contract.methods.hit().send({from: this.account, gas:100000000})
      .catch(err => {
        console.error('error hit ' + err);
      })

      this.get_player_score()
      //this.get_dealer_score()

      game = await this.contract.methods.get_game().call({ from: this.account }).catch(err => {console.error('error get_game ' + err);})

      console.log("this game after hit", game)
      await this.get_game()
      console.log("this player_arr",this.player_arr)


    },
    async get_player_score() {
      let player_score = await this.contract.methods.get_player_score().call({ from: this.account })
      .catch(err => {
        console.error('error get_player_score ' + err);
      })
      this.player_score = player_score
      console.log('get_player_score ',player_score)
    },
    async get_dealer_score() {
      let dealer_score = await this.contract.methods.get_dealer_score().call({ from: this.account })
      .catch(err => {
        console.error('error get_dealer_score ' + err);
      })
      this.dealer_score = dealer_score
      console.log('dealer_score ',dealer_score)
    }
  },
  async beforeMount() {

        // 获取当前余额，使用get_balance函数await this.contract.methods.get_balance().call()


    
    console.log("vuecontract", Vue.prototype.$contract)
    this.contract = Vue.prototype.$contract
    this.account = Vue.prototype.$account
    this.web3 = Vue.prototype.$web3
    console.log("contract", this.contract)

    let has = await this.contract.methods.get_balance().call({ from: this.account })
      .catch(err => {
        console.error('error get_balance ' + err);
      })
    
    console.log("balance0", has)
    this.balance = has
    console.log("balance init", this.balance)
    //this.get_game()
    console.log("this player_arr",this.player_arr)
    //this.open()

  },
};
</script>

<style scoped="scoped" lang="scss">
#match {
  height: 100vh;
  width: 100vw;
  display: flex;
  flex-wrap: wrap;
  align-content: space-between;

  .user_box {
    height: 30vh;
    width: 100vw;
    padding: 0 3vw;
    display: flex;

    .card_box {
      height: 28vh;
      margin: 1vh;
      width: 10vw;
      border-radius: 10px;
      box-shadow: 3px 3px 7px rgba(0, 0, 0, 0.3);

      p {
        text-align: center;
        font: 100px/200px Georgia, Times New Roman, serif;
      }

      &.no_see {
        background: #ccc;
      }
    }

    .current_score {
      height: 10vh;
      margin-top: 10vh;
      width: 10vw;
      font-size: 2vw;
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      align-content: center;

      .score_num {
        color: red;
        font-size: 3vw;
      }
    }
  }

  .player_box {
    display: flex;
    justify-content: space-between;

    .card_area {
      display: flex;
    }

    .money_area {
      width: 30vw;
      height: 28vh;
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      font-size: 3.5vw;
      border: 1px solid #ccc;

      div {
        height: 14vh;
        line-height: 14vh;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .money {
        justify-content: space-around;
      }

      button {
        width: 8vw;
        height: 6vh;
        font-size: 2vw;
        line-height: 6vh;
        padding: 0;
      }
    }
  }

  .operate_btn {
    width: 100vw;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: absolute;
    top: 0;
    left: 0;
    background: black;
    opacity: 0.5;

    div {
      width: 35vw;

      .click_btn {
        width: 23vw;
        height: 5vw;
        font-size: 2vw;
      }
    }
  }

  .bust_box {
    font-size: 5vw;
    color: red;
    font-weight: 600;
    position: absolute;
    display: none;

    &.dealer_win {
      display: block;
      left: 80vw;
      top: 10vh;
    }

    &.player_win {
      display: block;
      left: 80vw;
      top: 10vh;
    }

    &.even{
      display: block;
      left: 80vw;
      top: 10vh;
    }
  }
}
</style>
