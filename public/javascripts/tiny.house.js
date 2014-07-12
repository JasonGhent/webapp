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

	$('#loginForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		fields: {
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
					stringLength: {
						min: 6,
						message: 'The password must be at least six characters long'
					}
				}
			}
		}
	});

	$('#resetPasswordForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		fields: {
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

	$('#updateAccountForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
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
