function checkForm(form)
  {
    if(form.username.value == "") {
      alert("Error: File ID cannot be blank!");
      form.username.focus();
      return false;
    }
    if(form.pwd1.value != "" && form.pwd1.value == form.pwd2.value) {
      if(form.pwd1.value.length < 6) {
        alert("Error: Password must contain at least six characters!");
        form.pwd1.focus();
        return false;
      }
      if(form.pwd1.value == form.username.value) {
        alert("Error: Password must be different from Username!");
        form.pwd1.focus();
        return false;
      }
    } else {
      alert("Incorrect Hash Values");
      form.pwd1.focus();
      return false;
    }

    alert("Hash value Matches.. : " + form.pwd1.value);
    return true;
  }