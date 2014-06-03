function displaySuccess(message) {
	$("#alert-success").append(message);
	$("#alert-success").removeClass('hide');
}

$("#registerSubmit").click(function () {
	var name = $("#inputRegisterName").val();
	var email = $("#inputRegisterEmail").val();
	var password = $("#inputRegisterPassword").val();

	console.log(name);
	console.log(email);
	console.log(password);

	$.post("/register", {unsafeName: name, unsafeEmail: email, unsafePassword: password}, null, "json")
		.done(function(data) {
			displaySuccess(data.message);
		})
		.fail(function() {
			console.log('fail');
		});

	$("#registerModal").modal("hide");

	return false;
});

