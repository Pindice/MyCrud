import { createRouter, createWebHistory } from 'vue-router';
import PersonList from '@/components/PersonList.vue';

const routes = [
  {
    path: '/',
    name: 'PersonList',
    component: PersonList
  }
  // Ajoutez d'autres routes ici si nécessaire
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;


