<template>
  <div>
    <h1 class="text-center display-4">Person List</h1>

    <div class="container">
      <div class="fixed-form" v-if="!showConfirmation">
        <form @submit.prevent="submitForm" class="person-form">
          <div class="row">
            <div class="col-sm-6">
              <div class="form-group">
                <label>First Name:</label>
                <input v-model="form.first_name" type="text" class="form-control" maxlength="255" required>
              </div>
            </div>

          <div class="col-sm-6">
            <div class="form-group">
              <label>Last Name:</label>
              <input v-model="form.last_name" type="text" class="form-control" maxlength="255" required>
            </div>
          </div>

          <div class="col-sm-6">
            <div class="form-group">
              <label>Gender:</label>
              <select v-model="form.gender" class="form-control" required>
                <option value="" disabled selected hidden>Sélectionner une option</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
              </select>
            </div>
          </div>

          <div class="col-sm-6">
            <div class="form-group">
              <label>Phone Number:</label>
              <input v-model="form.phone_number" type="text" class="form-control" maxlength="20" required>
            </div>
          </div>

          <div class="col-sm-12">
            <div class="form-group">
              <label>Email:</label>
              <input v-model="form.email" type="email" class="form-control" maxlength="254" required>
            </div>
          </div>

          <div class="col-sm-12">
            <div class="form-group">
              <label>Personal Email:</label>
              <input v-model="form.email_personnal" type="email" class="form-control" maxlength="254" required>
            </div>
          </div>

          <div class="col-sm-12 mt-3">
            <div class="form-group d-flex justify-content-center">
              <button v-if="!editing" type="submit" class="btn btn-success">Add Person</button>
              <button v-else type="submit" class="btn btn-primary">Update Person</button>
              <button @click="cancelEdit" v-if="editing" class="red-button">Cancel</button>
            </div>
          </div>
        </div>
      </form>
    </div>

    <div class="table-responsive mx-auto">
      <table class="table">
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
          <tr v-for="person in persons" :key="person.id" :class="{'odd-row': person.id % 2 !== 0}">
            <td>{{ person.id }}</td>
            <td>{{ person.first_name }}</td>
            <td>{{ person.last_name }}</td>
            <td>{{ person.gender }}</td>
            <td>{{ person.phone_number }}</td>
            <td>{{ person.email }}</td>
            <td>{{ person.email_personnal }}</td>
            <td>
              <button @click="editPerson(person)" class="btn btn-primary">
                Edit <i class="fas fa-edit"></i>
              </button>
              <button @click="showDeleteConfirmation(person.id)" class="red-button">
                Delete <i class="fas fa-trash-alt"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

      <div v-if="notification" class="notification alert alert-info">
        {{ notification }}
      </div>

      <div v-if="showConfirmation" class="confirmation-modal">
        <div class="modal-content">
          <p>Are you sure you want to delete this person?</p>
          <div class="modal-actions">
            <button @click="deleteConfirmed" class="green-button">Yes</button>
            <button @click="deleteCancelled" class="red-button">No</button>
          </div>
        </div>
      </div>
    </div>
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
      originalForm: {},
      persons: [],
      editing: false,
      notification: '',
      showConfirmation: false,
      personToDeleteId: null,
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
        this.showNotification('Person added successfully.');
      } catch (error) {
        console.error(error.response);
        this.showNotification('Failed to add person. Please try again.', 'error');
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
        this.showNotification('Person updated successfully.');
        
        // Rafraîchir les données
        this.fetchPersons();
      } catch (error) {
        console.error(error.response);
        this.showNotification('Failed to update person. Please try again.', 'error');
      }
    },
    async editPerson(person) {
      this.form = { ...person };
      this.originalForm = { ...person };
      this.editing = true;
    },
    async deletePerson(personId) {
      this.personToDeleteId = personId;
      this.showConfirmation = true;
      try {
        const url = `http://localhost:8000/persons/${personId}/`;
        await axios.delete(url);
        this.persons = this.persons.filter(person => person.id !== personId);
        this.showNotification('Person deleted successfully.');
      } catch (error) {
        console.error(error.response);
        this.showNotification('Failed to delete person. Please try again.', 'error');
      }
    },
    async fetchPersons() {
      try {
        const response = await axios.get('http://localhost:8000/persons/');
        console.log(response.data);
        this.persons = response.data;
      } catch (error) {
        console.error(error.response);
        this.showNotification('Failed to fetch persons. Please try again.', 'error');
      }
    },
    cancelEdit() {
      this.form = { ...this.originalForm };
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
    },
    showNotification(message) {
      this.notification = message;
      setTimeout(() => {
        this.notification = '';
      }, 3000);
    },

    showDeleteConfirmation(personId) {
      this.personToDeleteId = personId;
      this.showConfirmation = true;
    },

    deleteConfirmed() {
      const personId = this.personToDeleteId;
      const url = `http://localhost:8000/persons/${personId}/`;
      axios
        .delete(url)
        .then(() => {
          this.persons = this.persons.filter(person => person.id !== personId);
          this.showNotification('Person deleted successfully.');
        })
        .catch(error => {
          console.error(error.response);
          this.showNotification('Failed to delete person. Please try again.', 'error');
        })
        .finally(() => {
          this.personToDeleteId = null;
          this.showConfirmation = false;
        });
    },
    deleteCanceled() {
      this.personToDeleteId = null;
      this.showConfirmation = false;
    },
  },
  mounted() {
    this.fetchPersons();
  },
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

th {
  font-weight: bold;
}

tr.odd-row {
  background-color: #f5f5f5;
}

button {
  margin-right: 5px;
  padding: 8px 12px;
  background-color: #4caf50;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s ease;
}

.fixed-form {
  position: sticky;
  top: 0;
  background-color: white;
  z-index: 999;
  padding: 10px;
}

.table-responsive {
  margin-top: 100px; /* Ajustez cette valeur en fonction de la hauteur du formulaire */
  max-height: calc(100vh - 200px); /* Ajustez cette valeur en fonction de la hauteur disponible */
  overflow-y: auto;
}

.red-button {
  margin-right: 5px;
  padding: 8px 12px;
  background-color: red;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #45a049;
}

button:active {
  background-color: #3c893d;
}

.notification {
  background-color: #f1f1f1;
  padding: 10px;
  text-align: center;
  margin-top: 10px;
  border-radius: 5px;
  color: #333;
}

.person-form {
  background-color: #f9f9f9;
  margin-top: 20px;
  padding: 10px;
  border-radius: 5px;
}

.form-row {
  margin-bottom: 10px;
}

.form-row label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

.form-row input,
.form-row select {
  width: 100%;
  padding: 5px;
  border: 1px solid #ddd;
  border-radius: 3px;
}

.form-actions {
  margin-top: 10px;
}

.fa-edit,
.fa-trash-alt {
  color: #333;
}

.fa-edit:hover,
.fa-trash-alt:hover {
  color: #ff0000;
}

.fa-edit {
  margin-right: 5px;
}

.fa-trash-alt {
  margin-left: 5px;
}

.confirmation-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 4px;
  max-width: 400px;
  text-align: center;
}

.modal-actions {
  margin-top: 20px;
}
</style>
