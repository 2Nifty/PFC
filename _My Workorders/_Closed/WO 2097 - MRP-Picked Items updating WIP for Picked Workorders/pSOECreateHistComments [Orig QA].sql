 
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E C r e a t e H i s t C o m m e n t s ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ u s e r n a m e   V A R C H A R ( 5 0 )   =   N U L L ,  
         @ o r d e r I D   B I G I N T   =   0  
 A S  
 B E G I N  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 C r a i g   P a r k s  
 - -   C r e a t e   d a t e :   1 1 / 1 2 / 2 0 0 8  
 - -   D e s c r i p t i o n : 	 C r e a t e   C o m m e n t s   f o r   R e l e a s e d   S a l e s   O r d e r s  
 - -   P a r a m e t e r s :   	 @ o r d e r I D   =   O r d e r   I D   o f   s o u r c e   O r d e r   S O H e a d e r ,  
 - -     @ u s e r n a m e     =   C a l l i n g   U s e r   N a m e ,  
 - -     @ o r d e r I D   =   R e l e a s e d   C o m m e n t s   I D   a n d   H i s t o r y   O r d e r   H e a d e r   O r d e r   N o  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
         - -   I n s e r t   s t a t e m e n t s   f o r   p r o c e d u r e   h e r e  
 I N S E R T   I N T O   d b o . S O C o m m e n t s H i s t   ( f S O H e a d e r H i s t I D ,   [ T y p e ] ,   F o r m s C d ,  
 C o m m L i n e N o ,   C o m m L i n e S e q N o ,   C o m m T e x t ,   D e l e t e D t ,   E n t r y I D , E n t r y D t )    
 S E L E C T   p S O H e a d e r H i s t I D ,   [ T y p e ] ,   F o r m s C d ,  
 C o m m L i n e N o ,   C o m m L i n e S e q N o ,   C o m m T e x t ,   S O C . D e l e t e D t ,   @ u s e r N a m e ,   G e t D a t e ( )  
 F R O M   d b o . S O C o m m e n t s R e l   ( N O L O C K )   S O C ,   S O H e a d e r H i s t   ( N O L O C K )   S O H H  
 W H E R E   f S O H e a d e r R e l I D   =   @ o r d e r I D   A N D   S O C . D e l e t e D t   I S   N U L L  
 A N D   ( ( [ T y p e ]   I N   ( ' C B ' ,   ' C T ' )   O R   ( [ T y p e ] =   ' L C '   A N D   C o m m L i n e N o   I N  
 ( S E L E C T     L i n e N u m b e r   F R O M   d b o . S O D e t a i l H i s t   ( N O L O C K )  
 W H E R E   f S O H e a d e r H i s t I D   =   p S O H e a d e r H i s t I D  
 A N D   S O C . D e l e t e D t   I S   N U L L ) ) ) )   A N D   S O H H . O r d e r N o   =   @ o r d e r I D  
 E N D  
  
  
  
  
  
  
  
 