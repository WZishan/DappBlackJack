<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
      <div class="card_box">
        <p>10</p>
      </div>
      <div class="card_box no_see">
      </div>
    </div>

    <div class="operate_btn">
      <div>
        <el-button class="click_btn" type="primary">HIT</el-button>
      </div>
      <div>
        <el-button class="click_btn" type="success">STAND</el-button>
      </div>
    </div>

    <div class="player_box user_box">
      <div class="money_area">
        筹码
      </div>
      <div class="card_area">
        <div class="card_box">
          <p>10</p>
        </div>
        <div class="card_box">
          <p>10</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "match",
  data() {
    return {};
  },
  methods: {
    open() {
      let max_num = 22;
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
        .then(({ value }) => {})
        .catch(() => {});
    },
  },
  beforeMount() {
    this.open();
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
  }
  
  
  .operate_btn{
    width: 100vw;
    height: 40vh;
    display: flex;
    align-items: center;
    justify-content: center;

    div {
      width: 35vw;
      .click_btn {
        width: 23vw;
        height: 5vw;
        font-size: 2vw;
      }
    }
  }
}
</style>
