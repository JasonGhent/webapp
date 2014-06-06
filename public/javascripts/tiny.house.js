$(document).ready(function() {
        $('#registerModal').on('shown.bs.modal', function () {
		$('#name').focus();
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
				console.log('response');
				if (result && result.success)
				{
					var successNotice = $('#success-alert').clone();
					successNotice.find('#success-message').text(result.message);

					$('#status').append(successNotice);
					successNotice.removeClass('hide');

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
			}
		}
	});

	console.log('Ready');
});
