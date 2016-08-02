$('#reservations .time-slot[data-id="<%= @reservation.id %>"]').fadeOut()
$('#available-slots .time-slot[data-slot="<%= local_time(@reservation.start_at).hour %>"]').fadeIn()
