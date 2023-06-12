import { createApp } from 'vue'
import App from './App.vue'
import axios from 'axios'
import router from './router';
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap/dist/js/bootstrap.js'


const app = createApp(App);
app.use(router);
app.mount('#app');

app.config.globalProperties.$http = axios;
