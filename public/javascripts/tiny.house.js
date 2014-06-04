//valid: 'fa fa-check',
//invalid: 'fa fa-times',
//validating: 'fa fa-spin fa-spinner'

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
					$('#success-message').text(result.message);
					$('#alert-success').removeClass('hide');

					$('#registerModal').modal('hide');
					$('#registerForm').bootstrapValidator('resetForm', true);
				}
				else if (result && result.error)
				{
				}
				else
				{
				}
			}, 'json');
		},
		fields: {
			name: {
				validators: {
					notEmpty: {
						message: 'The name field is required'
					}
				}
			},
			email: {
				validators: {
					notEmpty: {
						message: 'The email field is required'
					},
					emailAddress: {
						message: 'Please enter a valid email address'
					}
				}
			},
			password: {
				validators: {
					notEmpty: {
						message: 'The password field is required'
					},
					identical: {
						field: 'confirm',
						message: 'The password field and confirm field do not match'
					},
					stringLength: {
						min: 6,
						message: 'Your password must be at least six characters long'
					}
				}
			},
			confirm: {
				validators: {
					notEmpty: {
						message: 'The confirm field is required'
					},
					identical: {
						field: 'password',
						message: 'The password field and confirm field do not match'
					},
					stringLength: {
						min: 6,
						message: 'Your password must be at least six characters long'
					}
				}
			}
		}
	});
});
