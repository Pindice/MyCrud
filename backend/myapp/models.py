from django.db import models

# Create your models here.
class Person(models.Model):
    id = models.IntegerField(primary_key=True)
    first_name = models.CharField(max_length=255)
    last_name = models.CharField(max_length=255)
    gender = models.CharField(max_length=10)
    phone_number = models.CharField(max_length=20, blank=True)
    email = models.EmailField()
    email_personnal = models.EmailField(blank=True)

    def __str__(self):
        return self.first_name + ' ' + self.last_name