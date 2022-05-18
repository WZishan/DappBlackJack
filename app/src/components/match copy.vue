<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
      <div class="card_box" v-for="(item,index) in dealer_arr" :key="index" :class="{'no_see' : no_see_bool&& index == dealer_arr.length - 1}">
        <p v-if="no_see_bool&& index == dealer_arr.length - 1"></p>
        <p v-else>{{item}}</p>
      </div>
    </div>

    <div class="operate_btn" v-if="operate_show">
      <div>
        <el-button class="click_btn" type="primary" plain>HIT</el-button>
      </div>
      <div>
        <el-button class="click_btn" type="success" plain>STAND</el-button>
      </div>
    </div>

    <div class="player_box user_box">
      <div class="money_area">
        <p>bet:</p>
        <p>55</p>
      </div>
      <div class="card_area">
        <div class="card_box" v-for="(item,index) in player_arr" :key="index">
          <p>{{item}}</p>
        </div>
      </div>
    </div>
    <div class="bust_box" :class="{'dealer_win':dealer_win_bool,'player_win':player_win_bool}">
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
      web3: null,
      account: null,
      meta: null,
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
          this.sendCoin(value)
        })
        .catch(() => {});
    },
    async start() {
      const { web3 } = this;

      try {
        // get contract instance
        const networkId = await web3.eth.net.getId();
        const deployedNetwork = metaCoinArtifact.networks[networkId];
        this.meta = new web3.eth.Contract(
          metaCoinArtifact.abi,
          deployedNetwork.address
        );

        // get accounts
        const accounts = await web3.eth.getAccounts();
        this.account = accounts[0];

        this.refreshBalance();
      } catch (error) {
        console.error("Could not connect to contract or chain.");
      }
    },

    async refreshBalance() {
      const { getBalance } = this.meta.methods;
      const balance = await getBalance(this.account).call();

      this.balance = balance;
      this.open();
    },

    async sendCoin() {
      const amount = parseInt(document.getElementById("amount").value);
      const receiver = document.getElementById("receiver").value;
      const loading = this.$loading({
        lock: true,
        text: "Initiating transaction... (please wait)",
        spinner: "el-icon-loading",
        background: "rgba(0, 0, 0, 0.7)",
      });

      const { sendCoin } = this.meta.methods;

      await sendCoin(receiver, amount).send({
        from: this.account,
      });

      loading.close();
      this.$message({
        message: "Transaction complete!",
        type: "success",
      });
      this.refreshBalance();
    },
  },
  async beforeMount() {
    this.sendCoin()
    if (window.ethereum) {
      console.log("has");
      // use MetaMask's provider
      this.web3 = new Web3(window.ethereum);
      window.ethereum.enable(); // get permission to access accounts
    } else {
      console.warn(
        "No web3 detected. Falling back to http://127.0.0.1:8545. You should remove this fallback when you deploy live"
      );
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      this.web3 = new Web3(
        new Web3.providers.HttpProvider("http://127.0.0.1:8545")
      );
    }
    this.start();
    console.log(this.web3);
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
