 
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E C r e a t e H i s t E x p e n s e ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ u s e r n a m e   V A R C H A R ( 5 0 )   =   N U L L ,  
         @ o r d e r I D   B I G I N T   =   0  
 A S  
 B E G I N  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 C r a i g   P a r k s  
 - -   C r e a t e   d a t e :   1 1 / 1 2 / 2 0 0 8  
 - -   D e s c r i p t i o n : 	 C r e a t e   E x p e n s e s   f o r   R e l e a s e d   S a l e s   O r d e r s  
 - -   P a r a m e t e r s :   	 @ o r d e r I D   =   O r d e r   I D   o f   s o u r c e   O r d e r   S O H e a d e r ,  
 - -     @ u s e r n a m e     =   C a l l i n g   U s e r   N a m e ,  
 - -     @ o r d e r I D   =   R e l   E x p e n s e   f S O H e a d e r I D   a n d   H i s t o r y O r d e r   H e a d e r   O r d e r   N o  
 - -   M o d i f i e d :   1 / 1 4 / 2 0 0 9   C S P   A d d   E x p e n s e D e s c  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 	 S E T   N O C O U N T   O N ;  
  
         - -   I n s e r t   s t a t e m e n t s   f o r   p r o c e d u r e   h e r e  
 I N S E R T   I N T O   d b o . S O E x p e n s e H i s t   ( f S O H e a d e r H i s t I D ,   L i n e N u m b e r ,   E x p e n s e N o ,  
 E x p e n s e C d ,   A m o u n t ,   C o s t ,   E x p e n s e I n d ,   T a x S t a t u s ,   D e l i v e r y C h a r g e ,    
 H a n d l i n g C h a r g e ,   P a c k a g i n g C h a r g e ,   M i s c C h a r g e ,   P h o n e C h a r g e ,   D o c u m e n t L o c ,  
 D e l e t e D t ,   E n t r y I D ,   E n t r y D t ,   C h a n g e I D ,   C h a n g e D t ,   S t a t u s C d ,   E x p e n s e D e s c )   S E L E C T    
 S O H H . p S O H e a d e r H i s t I D ,   L i n e N u m b e r ,   E x p e n s e N o ,  
 E x p e n s e C d ,   A m o u n t ,   C o s t ,   E x p e n s e I n d ,   T a x S t a t u s ,   D e l i v e r y C h a r g e ,    
 H a n d l i n g C h a r g e ,   P a c k a g i n g C h a r g e ,   M i s c C h a r g e ,   P h o n e C h a r g e ,   D o c u m e n t L o c ,  
 S O E R . D e l e t e D t ,   @ u s e r N a m e ,   S O E R . E n t r y D t ,   S O E R . C h a n g e I D ,   S O E R . C h a n g e D t ,  
 S O E R . S t a t u s C d ,   E x p e n s e D e s c   F R O M   d b o . S O E x p e n s e R e l   ( N O L O C K )   S O E R ,  
 d b o . S O H e a d e r H i s t   ( N O L O C K )   S O H H  
 W H E R E   S O E R . f S O H e a d e r R e l I D   =   @ o r d e r I D   A N D   S O H H . O r d e r N o   =   @ o r d e r I D  
 A N D   S O E R . D e l e t e D t   I S   N U L L  
 E N D  
  
  
  
  
  
  
 