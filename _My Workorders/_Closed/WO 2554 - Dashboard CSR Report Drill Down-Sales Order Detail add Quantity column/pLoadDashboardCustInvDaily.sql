C R E A T E   P R O C E D U R E   [ d b o ] . [ p L o a d D a s h b o a r d C u s t I n v D a i l y ]  
 a s  
 - - - - p L o a d D a s h b o a r d C u s t I n v D a i l y  
 - - - - W r i t t e n   B y :   T o d   D i x o n  
 - - - - A p p l i c a t i o n :   S a l e s   M a n a g e m e n t  
 - - - - M o d i f i e d :   0 8 / 1 7 / 1 1   [ C S R ]   I g n o r e   S O H e a d e r H i s t   r e c o r d s   w h e r e   D e l e t e D t   i s   s e t  
 - - - - M o d i f i e d :   1 1 / 1 8 / 1 1   [ T M D ]   L o a d   n e w   Q t y S h i p p e d   f i e l d  
  
 D E C L A R E 	 @ C u r E n d D a y 	 D A T E T I M E , 	 - - C u r r e n t   D a s h B o a r d   E n d   D a t e  
 	 	 @ C u r M t h B e g 	 D A T E T I M E 	 - - B e g i n n i n g   D a t e   f o r   t h e   C u r r e n t   P e r i o d  
  
 S E T   @ C u r E n d D a y   =   ( S E L E C T   E n d D a t e   F R O M   D a s h B o a r d R a n g e s   W H E R E   D a s h B o a r d P a r a m e t e r   =   ' C u r r e n t D a y ' )  
 S E T   @ C u r M t h B e g   =   ( S E L E C T   C u r F i s c a l M t h B e g i n D t   F R O M   F i s c a l C a l e n d a r   W H E R E   C u r r e n t D t   =   @ C u r E n d D a y )  
  
 t r u n c a t e   t a b l e   D a s h b o a r d C u s t I n v D a i l y  
  
 - - D a i l y   r e c o r d s   b y   C u s t o m e r   &   I n v o i c e   ( D a s h b o a r d C u s t I n v D a i l y )  
 I N S E R T 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 ( I n v o i c e N o ,  
 	 	   R e f S O N o ,  
 	 	   C u s t N o ,  
 	 	   C u s t N a m e ,  
 	 	   L o c a t i o n ,  
 	 	   A R P o s t D t ,  
 	 	   I t e m N o ,  
 	 	   L i n e N u m b e r ,  
 	 	   O r d e r S o u r c e ,  
 	 	   O r d e r S o u r c e S e q ,  
 	 	   Q t y S h i p p e d ,  
 	 	   S a l e s D o l l a r s ,  
 	 	   L b s ,  
 	 	   S a l e s P e r L b ,  
 	 	   C o s t ,  
 	 	   M a r g i n D o l l a r s ,  
 	 	   M a r g i n P c t ,  
 	 	   M a r g i n P e r L b ,  
 	 	   E n t r y I D ,  
 	 	   E n t r y D t )  
 S E L E C T 	 t S a l e s . I n v o i c e N o ,  
 	 	 t S a l e s . O r d e r N o ,  
 	 	 t S a l e s . C u s t N o ,  
 	 	 t S a l e s . C u s t N a m e ,  
 	 	 t S a l e s . L o c a t i o n ,  
 	 	 t S a l e s . A R P o s t D t ,  
 	 	 t S a l e s . I t e m N o ,  
 	 	 t S a l e s . L i n e N u m b e r ,  
 	 	 t S a l e s . O r d e r S o u r c e ,  
 	 	 '   '   A S   O r d e r S o u r c e S e q ,  
 	 	 i s N U L L ( t S a l e s . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 i s N U L L ( t S a l e s . L i n e S a l e s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 i s N U L L ( t S a l e s . L i n e W g h t , 0 )   A S   L b s ,  
 	 	 i s N U L L ( t S a l e s . L i n e S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 i s N U L L ( t S a l e s . L i n e C o s t , 0 )   A S   C o s t ,  
 	 	 i s N U L L ( t S a l e s . L i n e M g n , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 i s N U L L ( t S a l e s . L i n e M g n P c t , 0 )   A S   M a r g i n P c t ,  
 	 	 i s N U L L ( t S a l e s . L i n e M g n P e r L b , 0 )   A S   M a r g i n P e r L b ,  
 	 	 ' N V L U N I G H T '   A S   E n t r y I D ,  
 	 	 G E T D A T E ( )   A S   E n t r y D t  
 F R O M 	 ( S E L E C T 	 D I S T I N C T  
 	 	 	 	 H d r . I n v o i c e N o ,  
 	 	 	 	 H d r . R e f S O N o   A S   O r d e r N o ,  
 	 	 	 	 H d r . S e l l T o C u s t N o   A S   C u s t N o ,  
 	 	 	 	 H d r . S e l l T o C u s t N a m e   A S   C u s t N a m e ,  
 	 	 	 	 - - H d r . C u s t S h i p L o c   A S   L o c a t i o n ,  
 	 	 	 	 i s N U L L ( C M . C u s t S h i p L o c a t i o n ,   H d r . C u s t S h i p L o c )   a s   L o c a t i o n ,  
 	 	 	 	 H d r . A R P o s t D t ,  
 	 	 	 	 D t l . I t e m N o ,  
 	 	 	 	 D t l . L i n e N u m b e r ,  
 	 	 	 	 H d r . O r d e r S o u r c e ,  
 	 	 	 	 D t l . Q t y S h i p p e d ,  
 	 	 	 	 D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d   A S   L i n e S a l e s ,  
 	 	 	 	 D t l . G r o s s W g h t   *   D t l . Q t y S h i p p e d   A S   L i n e W g h t ,  
 	 	 	 	 C A S E   ( D t l . G r o s s W g h t   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 	 	 W H E N   0   T H E N   0  
 	 	 	 	 	 	 E L S E   ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )   /   ( D t l . G r o s s W g h t   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 E N D   A S   L i n e S a l e s P e r L b ,  
 	 	 	 	 D t l . U n i t C o s t   *   D t l . Q t y S h i p p e d   A S   L i n e C o s t ,  
 	 	 	 	 ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )   -   ( D t l . U n i t C o s t   *   D t l . Q t y S h i p p e d )   A S   L i n e M g n ,  
 	 	 	 	 C A S E   ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 	 	 W H E N   0   T H E N   0  
 	 	 	 	 	 	 E L S E   ( ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )   -   ( D t l . U n i t C o s t   *   D t l . Q t y S h i p p e d ) )   /   ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 E N D   A S   L i n e M g n P c t ,  
 	 	 	 	 C A S E   ( D t l . G r o s s W g h t   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 	 	 W H E N   0   T H E N   0  
 	 	 	 	 	 	 E L S E   ( ( D t l . N e t U n i t P r i c e   *   D t l . Q t y S h i p p e d )   -   ( D t l . U n i t C o s t   *   D t l . Q t y S h i p p e d ) )   /   ( D t l . G r o s s W g h t   *   D t l . Q t y S h i p p e d )  
 	 	 	 	 E N D   A S   L i n e M g n P e r L b  
 	 	   F R O M 	 S O H e a d e r H i s t   H d r   ( N o L o c k )   F U L L   O U T E R   J O I N     - - I N N E R   J O I N  
 	 	 	 	 S O D e t a i l H i s t   D t l   ( N o L o c k )    
 	 	   O N 	 	 H d r . p S O H e a d e r H i s t I D   =   D t l . f S O H e a d e r H i s t I D   L E F T   O U T E R   J O I N  
 	 	 	 	 C u s t o m e r M a s t e r   C M   ( N o L o c k )  
 	 	   O N 	 	 H d r . S e l l T o C u s t N o   =   C M . C u s t N o  
 	 	   W H E R E 	 H d r . A R P o s t D t   b e t w e e n   @ C u r M t h B e g   a n d   @ C u r E n d D a y  
 	 	 	 	 A n d   I S N U L L ( H d r . D e l e t e D t , ' ' )   =   ' '  
 	 	 )   t S a l e s  
 O R D E R   B Y   C u s t N o ,   I n v o i c e N o ,   L i n e N u m b e r  
  
 - - U p d a t e   B L A N K   o r   N U L L   O r d e r S o u r c e   w i t h   D e f a u l t   V a l u e   f r o m   S O E O r d e r S o u r c e   L i s t  
 U P D A T E 	 D a s h b o a r d C u s t I n v D a i l y  
 S E T 	 	 O r d e r S o u r c e   =   L i s t . L i s t V a l u e  
 F R O M 	 ( S E L E C T 	 L D . L i s t V a l u e  
 	 	   F R O M 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C E R P D B ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P E R P . d b o . L i s t M a s t e r   L M   I N N E R   J O I N  
 	 	 	 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C E R P D B ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P E R P . d b o . L i s t D e t a i l   L D  
 	 	   O N 	 	 L M . p L i s t M a s t e r I D   =   L D . f L i s t M a s t e r I D  
 	 	   W H E R E 	 L M . L i s t N a m e   =   ' S O E O r d e r S o u r c e '   A N D   L D . S e q u e n c e N o = 9 )   L i s t  
 W H E R E 	 O r d e r S o u r c e   i s   n u l l   O R   O r d e r S o u r c e   =   ' '  
  
 - - U p d a t e   O r d e r S o u r c e S e q   w i t h   S e q u e n c e N o   f r o m   S O E O r d e r S o u r c e   L i s t  
 U P D A T E 	 D a s h b o a r d C u s t I n v D a i l y  
 S E T 	 	 O r d e r S o u r c e S e q   =   L i s t . S e q u e n c e N o  
 F R O M 	 ( S E L E C T 	 L D . L i s t V a l u e ,   L D . S e q u e n c e N o  
 	 	   F R O M 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C E R P D B ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P E R P . d b o . L i s t M a s t e r   L M   I N N E R   J O I N  
 	 	 	 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C E R P D B ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P E R P . d b o . L i s t D e t a i l   L D  
 	 	   O N 	 L M . p L i s t M a s t e r I D   =   L D . f L i s t M a s t e r I D  
 	 	   W H E R E 	 L M . L i s t N a m e   =   ' S O E O r d e r S o u r c e ' )   L i s t  
 W H E R E 	 O r d e r S o u r c e   =   L i s t . L i s t V a l u e  
 