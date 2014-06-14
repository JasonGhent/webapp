function getParam(param) {
	var half = location.search.split(param + '=')[1];
	return half? decodeURIComponent(half.split('&')[0]):null;
}

$(document).ready(function() {
        $('#registerModal').on('shown.bs.modal', function () {
		$('#registerName').focus();
	});

        $('#changePasswordModal').on('shown.bs.modal', function () {
		$('#changePasswordToken').val(getParam('changePasswordToken'));
		$('#changePasswordEmail').val(getParam('changePasswordEmail'));
		$('#changePasswordPassword').focus();
	});

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
			changePasswordToken: {
				validators: {
					notEmpty: {
						message: 'Please contact us for help'
					}
				}
			},
			changePasswordEmail: {
				validators: {
					notEmpty: {
						message: 'Please contact us for help'
					},
					emailAddress: {
						message: 'Please contact us for help'
					}
				}
			},
			changePasswordPassword: {
				validators: {
					notEmpty: {
						message: 'The password field is required'
					},
					stringLength: {
						min: 6,
						message: 'The password must be at least six characters long'
					},
					identical: {
						field: 'changePasswordConfirm',
						message: 'The password field and the confirm field do not match'
					}
				}
			},
			changePasswordConfirm: {
				validators: {
					notEmpty: {
						message: 'The password field is required'
					},
					stringLength: {
						min: 6,
						message: 'The password must be at least six characters long'
					},
					identical: {
						field: 'changePasswordPassword',
						message: 'The password field and the confirm field do not match'
					}
				}
			}
		}
	});

	if (location.hash == '#changePassword')
	{
		$('#changePasswordModal').modal('show') 
	}
});
