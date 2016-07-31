$('#reservations .time-slot[data-id="<%= @reservation.id %>"]').fadeOut()
$('#available-slots .time-slot[data-slot="<%= @reservation.start_at.hour %>"]').fadeIn()
