<template>
  <div id="app">
    <header class="header">
      <nav class="navbar navbar-expand-lg navbar-light bg-transparent">
        <div class="container">
          <a class="navbar-brand" href="#">My RH Solution</a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation" @click="toggleNavbar">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" :class="{ 'show': isNavbarVisible }" id="navbarNav">
            <ul class="navbar-nav ml-auto">
              <li class="nav-item active">
                <router-link to="/home" class="nav-link">Home</router-link>
              </li>
              <li class="nav-item">
                <router-link to="/person-list" class="nav-link">Person List</router-link>
              </li>
              <li class="nav-item">
                <a class="nav-link" href="/info">Info</a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>

    <main>
      <router-view></router-view>
    </main>
  </div>
</template>


<script>
export default {
  name: 'App',
  data() {
    return {
      isNavbarVisible: false
    };
  },
  methods: {
    toggleNavbar() {
      this.isNavbarVisible = !this.isNavbarVisible;
    }
  }
};
</script>

<style scoped>
.header {
  background-color: blue; /* Changez la couleur de fond selon vos préférences */
  color: white;
  padding: 10px;
  width: 100%;
}

.navbar-brand {
  color: white; /* Modifier la couleur */
  font-size: 24px; /* Modifier la taille */
}

.navbar-toggler {
  background-color: white;
  border: none;
  color: black;
  font-size: 20px;
  padding: 8px;
  cursor: pointer;
}

.navbar-toggler:focus {
  outline: none;
}

.navbar-toggler-icon {
  display: inline-block;
  color: white;
  width: 1.5em;
  height: 1.5em;
  vertical-align: middle;
  background-repeat: no-repeat;
  background-position: center;
  background-size: 100%;
  background-image: url(data:image/svg+xml;charset=utf-8,%3Csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='black' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3E%3C/svg%3E);
}

.nav-link {
  margin: 0 10px; /* Espacement horizontal entre les liens */
  color: white !important;
}

.show {
  display: block !important;
}

.navbar-nav > .nav-item.show {
  display: block;
}

nav {
  background-color: #f1f1f1;
  padding: 10px;
  margin-top: 10px;
}

nav ul {
  list-style: none;
  padding: 0;
}

nav li {
  margin-bottom: 10px;
}

main {
  margin-top: 60px; /* Ajustez la valeur selon la hauteur de l'entête */
}
</style>
