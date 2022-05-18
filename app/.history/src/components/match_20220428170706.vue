<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
      <div class="card_box">
        <p>10</p>
      </div>
      <div class="card_box no_see">
      </div>
    </div>
    <div class="player_box user_box">
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
  methods: {},
  beforeMount() {},
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
    padding: 0 5vw;
    display: flex;

    .card_box {
      height: 28vh;
      margin: 1vh;
      width: 10vw;
      border-radius: 10px;
      box-shadow: 3px 3px 7px rgba(0, 0, 0, 0.3);

      p {
        text-align: center;
        font: 100px/220px Georgia, Times New Roman, serif;
      }
      &.no_see {
        background: #ccc;
      }
    }
  }
  .player_box {
  }
}
</style>
