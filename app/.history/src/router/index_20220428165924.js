import Vue from 'vue'
import VueRouter from 'vue-router'
import index from '../components/index.vue'

Vue.use(VueRouter)

const routes = [{
    path: '/',
    components: {
        index
    }
}, {
    path: '/match',
    components: {
        index
    }
}, ]

const router = new VueRouter({
    routes
})

export default router