# Database_Booking-Process-of-a-Sports-Complex
This project requires to build a simple database to help manage the booking process of a sports complex.

The sports complex offers the following amenities: 2 tennis courts, 2 badminton courts, 2 multi-purpose fields, and 1 archery range. Each of these facilities is available for booking for one-hour durations.

Booking is restricted to registered users exclusively. Following the booking, users have the option to cancel their reservations up until the day prior to the scheduled date, with no charges. Nonetheless, if a user cancels for the third consecutive time or more, the complex enforces a Є10 penalty.

The database should have the following elements:

Tables
members pending_terminations rooms
bookings

View
member_bookings

Stored Procedures
insert_new_member 
delete_member 
update_member_password 
update_member_email 
make_booking 
update_payment 
view_bookings 
search_room 
cancel_booking

Trigger
payment_check

Stored Function
check_cancellation




