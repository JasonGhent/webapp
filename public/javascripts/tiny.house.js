$(document).ready(function() {
	$(function () { $("[data-toggle='tooltip']").tooltip(); });

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

	$('#placesForm').bootstrapValidator({
		message: 'This value is not valid',
		feedbackIcons: {
			valid: 'glyphicon glyphicon-ok',
			invalid: 'glyphicon glyphicon-remove',
			validating: 'glyphicon glyphicon-refresh'
		},
		fields: {
			place: {
				validators: {
					notEmpty: {
						message: 'The place field is required'
					}
				}
			},
			state: {
				validators: {
					notEmpty: {
						message: 'The state field is required'
					}
				}
			},
			adu: {
				validators: {
                                        integer: {
						message: 'You must specify a valid integer'
					}
				}
			},
			foundation: {
				validators: {
                                        integer: {
						message: 'You must specify a valid integer'
					}
				}
			},
			mobile: {
				validators: {
                                        integer: {
						message: 'You must specify a valid integer'
					}
				}
			}
		}
	});

        if ($('#map-canvas').length >= 1)
        {
		var map;

		// Get an object to center the map on
		var minneapolis = new google.maps.LatLng(44.970697, -93.2618534);

		// Make the map object
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

		// Load up the geo json
		map.data.loadGeoJson('http://tiny.house:3000/kml/Tiny.House.json');

		// Style the map
		map.data.setStyle(function(feature) {
			return updateStyles(feature);
		});

		// Handle resizing the map when the window is resized
		google.maps.event.addDomListener(window, "resize", function() {
		  var center = map.getCenter();
		  google.maps.event.trigger(map, "resize");
		  map.setCenter(center);
		});

		// Handle resizing the map when the map tab is clicked
		$("a[href='#map']").on('shown.bs.tab', function(){
		  google.maps.event.trigger(map, 'resize');
		});

		// The html element where you specify what size you want your tiny house to be
		tinyDiv = $('#square-feet-control');
		tinyDiv.removeClass('hidden');

		// Need to give the dom object to the map, not the jquery object, hence [0]
		map.controls[google.maps.ControlPosition.TOP_RIGHT].push(tinyDiv[0]);

		// The element for searching for places
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

		var square_feet = $('#square-feet');

		google.maps.event.addDomListener(square_feet[0], 'change', function() {
			map.data.setStyle(function(feature) {
				return updateStyles(feature);
			});
		});
	};

	$('.table > tbody > tr').click(function() {
		// row was clicked
		console.dir($(this));
		console.log($(this).attr('data-target'));
		window.location = $(this).attr('data-target');
	});
});

function updateStyles(feature) {
	var specifiedSize = $('#square-feet').val();
	var featureSize = feature.getProperty('size');

	var fill;
	var stroke;
 
	if (featureSize == -1) {
		fill = "#B5BAB6";
		stroke = "#666666";
	}
	else if (specifiedSize < featureSize) {
		fill = "#E52929";
		stroke = "#666666";
	}
	else {
		fill = "#29e529";
		stroke = "#666666";
	}

	return ({
		fillColor: fill,
		strokeColor: stroke,
		strokeWeight: 1,
	});
}
