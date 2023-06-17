#!/usr/bin/perl

use strict;
use warnings;
use DBI;
my ($id, $name, $age, $gender, $disease, $address);
my $driver = "mysql";
my $database = "Hospital";
my $dsn = "DBI:$driver:database=$database";
my $userid = "Piyush";
my $password = "Piyush1234";

my $dbh = DBI->connect($dsn, $userid, $password) or die $DBI::errstr;
print "\nConnected To Database :) \n";


sub add_patient {

print "\nEnter the Unique Id of the Patient: ";
my $id = <STDIN>;	
chomp($id);

my $key = $dbh->prepare("SELECT id from hospital where id = ?;");
my $temp = $key->execute($id);

if ($temp != 1) {

   print "Enter the name of the Patient: ";
   my $name = <STDIN>;
   chomp($name);

   print "Enter the age of the Patient: ";
   my $age = <STDIN>;
   chomp($age);

   print "Enter the gender of the Patient(F/M): ";
   my $gender = <STDIN>;
   chomp($gender);

   print "Enter the disease of the Patient: ";
   my $disease = <STDIN>;
   chomp($disease);

   print "Enter the address of the Patient : ";
   my $address = <STDIN>;
   chomp($address);

   my $sth = $dbh->prepare("INSERT INTO hospital (Id, Name, Age, Gender, Disease, Address ) VALUES (?, ?, ?, ?, ?, ?)");
   # Bind the values to the statement
   $sth->execute($id, $name, $age, $gender, $disease, $address);
   print "\nPatient added successfully\n";
}
  else {
  print "\nPatient Id already there !!!\n";
  }
}

sub update_patient {
  print "\nEnter the Patient id to update: ";
  my $id = <STDIN>;
  chomp($id);
  
  my $key = $dbh->prepare("SELECT id from hospital where id = ?;");
  my $temp = $key->execute($id);

  if($temp == 1) {
  my $choice=8;
  while($choice != 6) {
  
# Option to update
print "\nSelect the option you want to update:\n";
print "\n";
print "1. Patient Name\n";
print "2. Patient Age\n";
print "3. Patient Gender\n";
print "4. Patient Disease\n";
print "5. Patient Address\n";
print "6. Exit\n";
print "\n";
print "Enter Your choice: ";
$choice = <STDIN>;
chomp ($choice);

# Updating the selected detail
if  ($choice == 1) {
    print "\nEnter the Name of the Patient: ";
    my $name = <STDIN>;
    chomp $name;
    my $sth = $dbh->prepare("UPDATE hospital SET name = ? WHERE id = ?");
    $sth->execute($name,$id) or die $DBI::errstr;
    print "\nPatient Name updated successfully :) \n";
} elsif ($choice == 2) {
    print "\nEnter the  Age of the Patient: ";
    my $age = <STDIN>;
    chomp ($age);
    my $sth = $dbh->prepare("UPDATE hospital SET age = ? WHERE id = ?");
    $sth->execute($age,$id) or die $DBI::errstr;
    print "\nPatient Age updated successfully :) \n";
} elsif ($choice == 3) {
    print "\nEnter the Gender of the Patient(F/M): ";
    my $gender = <STDIN>;
    chomp ($gender);
    my $sth = $dbh->prepare("UPDATE hospital SET gender = ? WHERE id = ?");
    $sth->execute($gender,$id) or die $DBI::errstr;
    print "\nPatient Gender updated successfully :) \n";
} elsif ($choice ==4){
    print "\nEnter the  Disease of the Patient: ";
    my $disease = <STDIN>;
    chomp ($disease);
    my $sth = $dbh->prepare("UPDATE hospital SET disease = ? WHERE id = ?");
    $sth->execute($disease,$id) or die $DBI::errstr;
    print "\nPatient Disease updated successfully :) \n";
} elsif ($choice == 5) {
    print "\nEnter the  Address of the Patient: ";
    my $address = <STDIN>;
    chomp ($address);
    my $sth = $dbh->prepare("UPDATE hospital SET name = ? WHERE id = ?");
    $sth->execute($address,$id) or die $DBI::errstr;
    print "\nPatient Address updated successfully :) \n";
} elsif ($choice == 6) {
    print "\nExit Successfully :) \n";
} else {
    print "Invalid Choice :(";
  }    
}
}

  else  {
    print "Patient id does not exist";

  }

}
sub delete_patient {
  print "\nEnter the patient Id to delete: ";
  $id = <STDIN>;
  chomp($id);
  
  my $key = $dbh->prepare("SELECT id from hospital where id = ?;");
  my $temp = $key->execute($id);

  if($temp == 1) {
# Check if name exists
  my $sth = $dbh->prepare("DELETE FROM hospital WHERE id = ?");
  $sth->execute($id); 
  print "\nPatient $id Deleted Successfull :) \n";
  }
  else {
  print "Patient Id does not exist"; 
  } 
}
sub view_patients {
  print "\nEnter the name of the table to view: "; 
  my $table_name = <STDIN>;
  print "\n";
  chomp($table_name);

# Check if table exists
  my $sth = $dbh->prepare("SELECT * FROM $table_name");
  $sth->execute() or die "Table $table_name Not Found in Database $database \n";

  if ($table_name) {
    print "Table $table_name exists in database $database :) \n";
    print "\n";
} else {
    print "Table $table_name does not exist in database $database :( \n";
}
# Printing column names
print join("\t", @{$sth->{NAME}}) . "\n";
# Fetching and printing results
  while (my @row = $sth->fetchrow_array()) {
   print join("\t", @row) . "\n";
}
}

while (1) {
  print "\nHospital Management System Welcomes You :) \n";
  print "\n";
  print "1. Add Patient\n";
  print "2. Update Patient\n";
  print "3. Delete Patient\n";
  print "4. View   Patients\n";
  print "5. Exit\n";
  print "\n";

  print "Enter your choice: ";
  my $choice = <STDIN>;
  chomp($choice);

  if ($choice == 1) {
    add_patient();
  } elsif ($choice == 2) {
    update_patient();
  } elsif ($choice == 3) {
    delete_patient();
  } elsif ($choice == 4) {
    view_patients();
  } elsif ($choice == 5) {
    print "\nYou are Succesfully Logged Out :) \n";
    print "\n";
    last;
  } else {
    print "\nInvalid Choice :( \n";
    print "\n"; 
  }
}