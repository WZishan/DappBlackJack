<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
      <div class="card_box" v-for="(item, index) in dealer_arr" :key="index"
        :class="{ 'no_see': no_see_bool && index == dealer_arr.length - 1 }">
        <p v-if="no_see_bool && index == dealer_arr.length - 1"></p>
        <p v-else>{{ item }}</p>
      </div>
    </div>

    <div class="operate_btn" v-if="operate_show">
      <div>
        <el-button class="click_btn" type="primary" plain @click="hit">HIT</el-button>
      </div>
      <div>
        <el-button class="click_btn" type="success" plain @click="stand">STAND</el-button>
      </div>
    </div>

    <div class="player_box user_box">
      <div class="money_area">
        <p>bet:</p>
        <p>55</p>
      </div>
      <div class="card_area">
        <div class="card_box" v-for="(item, index) in player_arr" :key="index">
          <p>{{ item }}</p>
        </div>
      </div>
    </div>
    <div class="bust_box" :class="{ 'dealer_win': dealer_win_bool, 'player_win': player_win_bool }">
      Bust!
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
export default {
  name: "match",
  data() {
    return {
      operate_show: false,
      no_see_bool: true,
      dealer_arr: [10, 10],
      player_arr: [10, 10],
      dealer_win_bool: false,
      player_win_bool: false,

      balance: "",
      player_score: '',
      dealer_score: "",
      stand_num: 0
    };
  },
  methods: {
    open() {
      let max_num = this.balance;
      this.$prompt(
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
            let RegExp = /(^[\-0-9][0-9]*(.[0-9]+)?)$/;
            return RegExp.test(value) && value <= max_num;
          },
          inputErrorMessage: "Invalid number",
        }
      )
        .then(({ value }) => {
          //下注，使用bet函数
          bet(value)
        })
        .catch(() => { });
    },
    async get_game() {
      let result = await get_game().tuple
      this.stand_num = this.stand_num + 1
      //下注金额
      let bet = result[0]
      // 庄家隐藏牌
      let dealer_hidden_card = result[1]
      // 庄家牌组
      let dealer_card = result.slice(2, this.stand_num)
      this.dealer_arr = [...dealer_card,...dealer_hidden_card]
      // 玩家牌组
      let player_card = result.slice(this.stand_num + 2, result.length - 1)
      this.player_arr =player_card
      // 是否结束
      let game_result = result[result.length - 1]
    },
    async get_result() {
      let result = await get_result()['decoded output'][0].split(':')[1]
      if (result == 1) {
        // player win
        this.player_win_bool = true
        this.dealer_win_bool = false
      } else if (result == 2) {
        // dealer win
        this.player_win_bool = false
        this.dealer_win_bool = true
      } else {
        this.player_win_bool = false
        this.dealer_win_bool = false
      }
    },
    async stand() {
      await stand()
    },
    async hit() {
      await hit()
    },
    async get_player_score() {
      let player_score = await get_player_score()['decoded output'][0].split(':')[1]
      this.player_score = player_score
    },
    async get_dealer_score() {
      let dealer_score = await get_dealer_score()['decoded output'][0].split(':')[1]
      this.dealer_score = dealer_score
    }
  },
  async beforeMount() {
    // 获取当前余额，使用get_balance函数
    let has = await get_balance()
    this.balance = has
    this.open()
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
  }

  .player_box {
    display: flex;
    justify-content: space-between;

    .card_area {
      display: flex;
    }

    .money_area {
      width: 20vw;
      height: 28vh;
      line-height: 28vh;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3.5vw;
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
      left: 30vw;
      top: 80vh;
    }
  }
}
</style>
