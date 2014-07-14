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

	var map, layer;

	var minneapolis = new google.maps.LatLng(44.970697, -93.2618534);

	map = new google.maps.Map(document.getElementById('map-canvas'), {
		center: minneapolis,
		zoom: 11,
		panControl: true,
		zoomControl: true,
		mapTypeControl: false,
		scaleControl: true,
		streetViewControl: false,
		overviewMapControl:true 
	});

	layer = new google.maps.FusionTablesLayer({
		query: {
			select: '\'Geocodable address\'',
			from: '17p9tskvyeMz_CRuqr8zaBE6M5aVYGgg5dTiXA7A'
		},
		styles: [{
			where: "'Size' < 500",
			polygonOptions: {
				fillColor: "#FF6600",
				strokeColor: "#FFFFFF",
				strokeWeight: 2
			}
			}, {
				where: "'Size' >= 500",
				polygonOptions: {
				fillColor: "#00CCCC",
				strokeColor: "#FFFFFF",
				strokeWeight: 3
			}
		}]
	});

	layer.setMap(map);	

	tinyDiv = $('#square-feet-control');
	tinyDiv.removeClass('hidden');

	// Need to give the dom object to the map, not the jquery object, hence [0]
	map.controls[google.maps.ControlPosition.TOP_RIGHT].push(tinyDiv[0]);


	var searchCustomControl = $('#search-control-container');
	searchCustomControl.removeClass('hidden');

	// Need to give the dom object to the map, not the jquery object, hence [0]
	map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchCustomControl[0]);

	var searchInput = $('#search-control');
	var searchBox = new google.maps.places.Autocomplete(searchInput[0]);

	google.maps.event.addListener(searchBox, 'place_changed', function() {
		var place = searchBox.getPlace();

		if (!place.geometry) {
			return;
		}
	
		if (place.geometry.viewport) {
			map.fitBounds(place.geometry.viewport);
		} else {
			map.setCenter(place.geometry.location);
		}		
	});
});
