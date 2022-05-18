<template>
  <div id="index" ref="mainHeight">
    <div class="header">
      Welcome To BlackJack
    </div>
    <div class="btn_content">
      <div>
        <el-button class="click_btn" @click="start_click">START</el-button>
      </div>
      <div>
        <el-button class="click_btn">EXIT</el-button>
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
import BlackJackArtifact from "../../../build/contracts/BlackJack.json";
import Vue from 'vue'


export default {
  name: "index",
  data() {
    return {};
  },
  web3: null,
  account: null,
  contract:null,

  methods: {
    async start_click() {
      
      if (window.ethereum) {
        
        // use MetaMask's provider
        this.web3 = new Web3(window.ethereum);
        window.ethereum.enable(); // get permission to access accounts
      } else {
        console.warn(
          "No web3 detected. Falling back to http://127.0.0.1:8575. You should remove this fallback when you deploy live",
        );
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        this.web3 = new Web3(
          new Web3.providers.HttpProvider("http://127.0.0.1:8575"),
        );
      }

      const { web3 } = this;

    try {
      // get contract instance
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = BlackJackArtifact.networks[networkId];
      this.contract = new web3.eth.Contract(
        BlackJackArtifact.abi,
        deployedNetwork.address,
      );
      console.log("contract", this.contract)
      // get accounts
      const accounts = await web3.eth.getAccounts();
      this.account = accounts[0];
      console.log("account", this.account);
      const gasAmount = await this.contract.methods
        .initialize_game().estimateGas({ from: this.account });
      console.log("gasAmount", gasAmount)
      this.contract.methods
        .initialize_game()
        .send({ from: this.account, gas: gasAmount });

    } catch (error) {
      console.error("Could not connect to contract or chain.");
    }
    Vue.prototype.$contract=this.contract
    Vue.prototype.$account=this.account
    Vue.prototype.$web3=this.web3
    console.log("vuecontract", Vue.prototype.$contract)
    this.$router
        .push({
          path: "/match",
        })
        .catch((err) => {
          err;
        });
    },
  },




  beforeMount() {
    try{
      //location.reload()
      location=location
      location.assign(location)
    } catch (error) {
      console.error("Could not reloas");
    }
    //history.go(0) 
  },
  
};
</script>

<style scoped="scoped" lang="scss">
#index {
  .header {
    height: 30vh;
    width: 100vw;
    line-height: 30vh;
    text-align: center;
    font-size: 5vw;
  }
  .btn_content {
    height: 70vh;
    width: 100vw;
    display: flex;
    align-content: center;
    justify-content: center;
    flex-wrap: wrap;
    div {
      width: 100%;
      height: 20vh;
      .click_btn {
        width: 23vw;
        height: 5vw;
        font-size: 2vw;
      }
    }
  }
}
</style>
