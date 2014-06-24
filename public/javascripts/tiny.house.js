function getParam(param) {
	var half = location.search.split(param + '=')[1];
	return half? decodeURIComponent(half.split('&')[0]):null;
}

$(document).ready(function() {
	$('#registerForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		submitHandler: function(validator, form, submitButton) {
			$.post('/register', form.serialize(), function(result) {
				if (result && result.success)
				{
					var successNotice = $('#success-alert').clone();
					successNotice.find('#success-message').text(result.message);

					$('#status').append(successNotice);
					successNotice.removeClass('hide');

					$('#registerModal').modal('hide');
					$('#registerForm').bootstrapValidator('resetForm', true);
				}
				else
				{
				}
			}, 'json')
				.fail(function() {
			});
		},
		fields: {
			registerName: {
				validators: {
					notEmpty: {
						message: 'The name field is required'
					}
				}
			},
			registerEmail: {
				validators: {
					notEmpty: {
						message: 'The email field is required'
					},
					emailAddress: {
						message: 'Please enter a valid email address'
					},
					remote: {
						message: 'That email address is already in use',
						url: '/check_email_address'
					}
				}
			}
		}
	});

	$('#changePasswordForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		submitHandler: function(validator, form, submitButton) {
			$.post('/change_password', form.serialize(), function(result) {
				if (result && result.success)
				{
					var successNotice = $('#success-alert').clone();
					successNotice.find('#success-message').text(result.message);

					$('#status').append(successNotice);
					successNotice.removeClass('hide');

					$('#changePasswordModal').modal('hide');
					$('#changePasswordForm').bootstrapValidator('resetForm', true);
				}
				else
				{
				}
			}, 'json')
				.fail(function() {
			});
		},
		fields: {
			token: {
				validators: {
					notEmpty: {
						message: 'Please contact us for help'
					}
				}
			},
			email: {
				validators: {
					notEmpty: {
						message: 'Please contact us for help'
					},
					emailAddress: {
						message: 'Please contact us for help'
					}
				}
			},
			password: {
				validators: {
					notEmpty: {
						message: 'The password field is required'
					},
					stringLength: {
						min: 6,
						message: 'The password must be at least six characters long'
					},
					identical: {
						field: 'confirm',
						message: 'The password field and the confirm field do not match'
					}
				}
			},
			confirm: {
				validators: {
					notEmpty: {
						message: 'The password field is required'
					},
					stringLength: {
						min: 6,
						message: 'The password must be at least six characters long'
					},
					identical: {
						field: 'password',
						message: 'The password field and the confirm field do not match'
					}
				}
			}
		}
	});
});
