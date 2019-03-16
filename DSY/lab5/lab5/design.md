# redis example design notes

version of message service from lab4 (RMI)

message:MAILBOX:ID -> hash
- subject
- body

message_next_id

pub/sub message:MAILBOX w message key
