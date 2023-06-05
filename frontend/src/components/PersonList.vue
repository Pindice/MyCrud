<template>
    <div>
      <h1>Person List</h1>
  
      <!-- Formulaire pour ajouter ou mettre à jour une personne -->
      <form @submit.prevent="submitForm">
        <label>First Name:</label>
        <input v-model="form.first_name" type="text" required>
  
        <label>Last Name:</label>
        <input v-model="form.last_name" type="text" required>
  
        <label>Gender:</label>
        <select v-model="form.gender" required>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>
  
        <label>Phone Number:</label>
        <input v-model="form.phone_number" type="text" required>
  
        <label>Email:</label>
        <input v-model="form.email" type="email" required>
  
        <label>Personal Email:</label>
        <input v-model="form.email_personnal" type="email" required>
  
        <button v-if="!editing" type="submit">Add Person</button>
        <button v-else type="submit">Update Person</button>
        <button @click="cancelEdit" v-if="editing">Cancel</button>
      </form>
  
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Gender</th>
            <th>Phone Number</th>
            <th>Email</th>
            <th>Personal Email</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="person in persons" :key="person.id">
            <td>{{ person.id }}</td>
            <td>{{ person.first_name }}</td>
            <td>{{ person.last_name }}</td>
            <td>{{ person.gender }}</td>
            <td>{{ person.phone_number }}</td>
            <td>{{ person.email }}</td>
            <td>{{ person.email_personnal }}</td>
            <td>
              <button @click="editPerson(person)">Edit</button>
              <button @click="deletePerson(person.id)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        form: {
          id: null,
          first_name: '',
          last_name: '',
          gender: '',
          phone_number: '',
          email: '',
          email_personnal: ''
        },
        persons: [],
        editing: false
      };
    },
    methods: {
      async submitForm() {
        if (this.editing) {
          await this.updatePerson();
        } else {
          await this.addPerson();
        }
      },
      async addPerson() {
        try {
          const response = await axios.post('http://localhost:8000/persons/', this.form);
          const createdPerson = response.data;
          this.persons.push(createdPerson);
          this.clearForm();
        } catch (error) {
          console.error(error.response);
        }
      },
      async updatePerson() {
        try {
          const url = `http://localhost:8000/persons/${this.form.id}/`;
          await axios.put(url, this.form);
          const updatedPersonIndex = this.persons.findIndex(person => person.id === this.form.id);
          this.$set(this.persons, updatedPersonIndex, this.form);
          this.clearForm();
          this.editing = false;
        } catch (error) {
          console.error(error.response);
        }
      },
      async editPerson(person) {
        this.form = { ...person };
        this.editing = true;
      },
      async deletePerson(personId) {
        try {
          const url = `http://localhost:8000/persons/${personId}/`;
          await axios.delete(url);
          this.persons = this.persons.filter(person => person.id !== personId);
        } catch (error) {
          console.error(error.response);
        }
      },
      async fetchPersons() {
        try {
          const response = await axios.get('http://localhost:8000/persons/');
          this.persons = response.data;
        } catch (error) {
          console.error(error.response);
        }
      },
      cancelEdit() {
        this.clearForm();
        this.editing = false;
      },
      clearForm() {
        this.form = {
          id: null,
          first_name: '',
          last_name: '',
          gender: '',
          phone_number: '',
          email: '',
          email_personnal: ''
        };
      }
    },
    mounted() {
      this.fetchPersons();
    }
  };
  </script>
  
  <style scoped>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  
  th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }
  
  button {
    margin-right: 5px;
  }
  </style>
  