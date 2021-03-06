C R E A T E   p r o c e d u r e   [ d b o ] . [ p D a s h b o a r d S O D r i l l d o w n M T D ]  
 @ L o c   v a r c h a r ( 2 0 ) ,  
 @ C u s t N o   v a r c h a r ( 2 0 ) ,  
 @ I n v o i c e N o   v a r c h a r ( 2 0 )  
 a s  
  
 - - - - p D a s h b o a r d S O D r i l l d o w n M T D  
 - - - - W r i t t e n   B y :   T o d   D i x o n  
 - - - - A p p l i c a t i o n :   S a l e s   M a n a g e m e n t  
  
 D E C L A R E   @ C u r E n d D a y   D A T E T I M E 	 - - C u r r e n t   D a s h B o a r d   E n d   D a t e  
 D E C L A R E 	 @ C u r M t h B e g   D A T E T I M E 	 - - B e g i n n i n g   D a t e   f o r   t h e   C u r r e n t   P e r i o d  
  
 S E T 	 @ C u r E n d D a y   =   ( S E L E C T   E n d D a t e   F R O M   D a s h B o a r d R a n g e s   W H E R E   D a s h B o a r d P a r a m e t e r   =   ' C u r r e n t D a y ' )  
 S E T 	 @ C u r M t h B e g   =   ( S E L E C T   C u r F i s c a l M t h B e g i n D t   F R O M   F i s c a l C a l e n d a r   W H E R E   C u r r e n t D t   =   @ C u r E n d D a y )  
 - - S E L E C T 	 @ C u r E n d D a y   a s   C u r E n d D a y ,   @ C u r M t h B e g   a s   C u r M t h B e g  
  
 - - C u s t o m e r   N u m b e r   D e t a i l   D r i l l d o w n  
 I F   @ C u s t N o   < >   ' 0 0 0 0 0 0 '   A N D   @ C u s t N o   < >   ' * * * * * * '  
       B E G I N  
 	 S E L E C T 	 D I S T I N C T  
 	 	 O r d e r D t l . C u s t N o ,  
 	 	 O r d e r D t l . C u s t N a m e ,  
 	 	 O r d e r S u m . I n v o i c e N o ,  
 	 	 O r d e r D t l . L o c a t i o n ,  
 	 	 O r d e r D t l . A r P o s t D t ,  
 	 	 O r d e r D t l . O r d e r S o u r c e ,  
 	 	 O r d e r D t l . O r d e r S o u r c e S e q ,  
 	 	 I S N U L L ( O r d e r S u m . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 I S N U L L ( O r d e r S u m . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 I S N U L L ( O r d e r S u m . L b s , 0 )   A S   L b s ,  
 	 	 I S N U L L ( O r d e r S u m . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 I S N U L L ( O r d e r S u m . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 I S N U L L ( O r d e r S u m . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
 	 	 I S N U L L ( O r d e r S u m . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 F R O M 	 ( S E L E C T 	 I n v o i c e N o ,  
 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d ,  
 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s ,  
 	 	 	 S U M ( L b s )   A S   L b s ,  
 	 	 	 C A S E   S U M ( L B S )  
 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	     E L S E   S U M ( S a l e s D o l l a r s )   /   S U M ( L b s )  
 	 	 	 E N D   A S   S a l e s P e r L b ,  
 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 C A S E   S U M ( L B S )  
 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	     E L S E   ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( L b s )  
 	 	 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 E N D   A S   M a r g i n P c t  
 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	   W H E R E 	 C u s t N o   =   @ C u s t N o   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
 	 	   G R O U P   B Y   I n v o i c e N o )   O r d e r S u m  
 	 	 I N N E R   J O I N  
 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 C u s t N a m e ,  
 	 	 	 I n v o i c e N o ,  
 	 	 	 L o c a t i o n ,  
 	 	 	 A r P o s t D t ,  
 	 	 	 O r d e r S o u r c e ,  
 	 	 	 O r d e r S o u r c e S e q  
 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	   W H E R E 	 C u s t N o   =   @ C u s t N o   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y )   O r d e r D t l  
 	 	 O N 	 O r d e r S u m . I n v o i c e N o   =   O r d e r D t l . I n v o i c e N o  
  
 	 S E L E C T 	 ' - - C u s t o m e r   N u m b e r   D e t a i l   D r i l l d o w n   ( '   +   @ C u s t N o   +   ' ) '  
       E N D  
  
 - - I n v o i c e   N u m b e r   D e t a i l   D r i l l d o w n  
 I F   @ I n v o i c e N o   < >   ' 0 0 0 0 0 0 0 0 0 0 '   A N D   @ I n v o i c e N o   < >   ' * * * * * * * * * * '  
       B E G I N  
 	 S E T 	 @ C u s t N o   =   ( S E L E C T   D I S T I N C T   C u s t N o   F R O M   D a s h b o a r d C u s t I n v D a i l y   W H E R E   I n v o i c e N o   =   @ I n v o i c e N o )  
 - - 	 S E L E C T 	 @ C u s t N o  
  
 	 S E L E C T 	 D I S T I N C T  
 	 	 C u s t N o ,  
 	 	 C u s t N a m e ,  
 	 	 I n v o i c e N o ,  
 	 	 L o c a t i o n ,  
 	 	 A r P o s t D t ,  
 	 	 O r d e r S o u r c e ,  
 	 	 O r d e r S o u r c e S e q ,  
 	 	 L i n e N u m b e r ,  
 	 	 I t e m N o ,  
 	 	 I S N U L L ( Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 I S N U L L ( S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 I S N U L L ( L b s , 0 )   A S   L b s ,  
 	 	 I S N U L L ( S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 I S N U L L ( M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 I S N U L L ( M a r g i n P c t , 0 )   *   1 0 0   A S   M a r g i n P c t ,  
 	 	 I S N U L L ( M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 W H E R E 	 I n v o i c e N o   =   @ I n v o i c e N o  
  
 	 S E L E C T 	 ' - - I n v o i c e   N u m b e r   D e t a i l   D r i l l d o w n   ( '   +   @ I n v o i c e N o   +   ' ) '  
       E N D  
  
 I F   @ L o c   =   ' 0 0 ' 	 	 - - A L L   L O C A T I O N S  
       B E G I N  
 	 - - I n v o i c e   L i n e   I t e m   D e t a i l   D r i l l d o w n  
 	 I F   @ C u s t N o   =   ' 0 0 0 0 0 0 '   A N D   @ I n v o i c e N o   =   ' 0 0 0 0 0 0 0 0 0 0 '  
 	       B E G I N  
 	 	 S E T 	 @ C u s t N o   =   ' ~ ~ ~ ~ ~ ~ '  
  
 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 C u s t N o ,  
 	 	 	 C u s t N a m e ,  
 	 	 	 I n v o i c e N o ,  
 	 	 	 L o c a t i o n ,  
 	 	 	 A r P o s t D t ,  
 	 	 	 O r d e r S o u r c e ,  
 	 	 	 O r d e r S o u r c e S e q ,  
 	 	 	 L i n e N u m b e r ,  
 	 	 	 I t e m N o ,  
 	 	 	 I S N U L L ( Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( M a r g i n P c t , 0 )   *   1 0 0   A S   M a r g i n P c t ,  
 	 	 	 I S N U L L ( M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 	 F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 W H E R E 	 I t e m N o   I S   N O T   N U L L   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
  
 	 	 S E L E C T 	 ' - - I n v o i c e   L i n e   I t e m   D e t a i l   D r i l l d o w n   ( A l l   L o c a t i o n s ) '  
 	       E N D  
  
 	 - - R e p o r t   A   -   S a l e s   O r d e r   H e a d e r   L e v e l  
 	 I F   @ C u s t N o   =   ' * * * * * * '  
 	       B E G I N  
 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 O r d e r D t l . C u s t N o ,  
 	 	 	 O r d e r D t l . C u s t N a m e ,  
 	 	 	 O r d e r S u m . I n v o i c e N o ,  
 	 	 	 O r d e r D t l . L o c a t i o n ,  
 	 	 	 O r d e r D t l . A r P o s t D t ,  
 	 	 	 O r d e r D t l . O r d e r S o u r c e ,  
 	 	 	 O r d e r D t l . O r d e r S o u r c e S e q ,  
 	 	 	 I S N U L L ( O r d e r S u m . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( O r d e r S u m . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( O r d e r S u m . L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( O r d e r S u m . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 	 F R O M 	 ( S E L E C T 	 I n v o i c e N o ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 S U M ( L b s )   A S   L b s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   S U M ( S a l e s D o l l a r s )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
 	 	 	   G R O U P   B Y   I n v o i c e N o )   O r d e r S u m  
 	 	 	 I N N E R   J O I N  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 I n v o i c e N o ,  
 	 	 	 	 L o c a t i o n ,  
 	 	 	 	 A r P o s t D t ,  
 	 	 	 	 O r d e r S o u r c e ,  
 	 	 	 	 O r d e r S o u r c e S e q  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y )   O r d e r D t l  
 	 	 	 O N 	 O r d e r S u m . I n v o i c e N o   =   O r d e r D t l . I n v o i c e N o  
  
 	 	 S E L E C T 	 ' - - R e p o r t   A   -   S a l e s   O r d e r   H e a d e r   L e v e l   ( A l l   L o c a t i o n s ) '  
 	       E N D  
  
 	 - - R e p o r t   B   -   C u s t o m e r   S a l e s   O r d e r   L e v e l  
 	 I F   @ C u s t N o   =   ' 0 0 0 0 0 0 '  
 	       B E G I N  
 	 	 S E L E C T 	 C u s t A l l . C u s t N o ,  
 	 	 	 C u s t A l l . C u s t N a m e ,  
 	 	 	 I S N U L L ( C u s t A l l . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( C u s t A l l . L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( C u s t A l l . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
  
 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   a s   M T D G o a l D o l ,  
 	 	 	 I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l G M P c t ,  
 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l M g n D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D S a l e s D o l , 0 )   a s   Y T D S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   a s   Y T D G o a l D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l G M P c t ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l M g n D o l ,  
  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 S a l e s D o l , 0 )   a s   P r e v M t h 1 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 S a l e s D o l , 0 )   a s   P r e v M t h 2 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 S a l e s D o l , 0 )   a s   P r e v M t h 3 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 G M P c t , 0 )   a s   P r e v M t h 1 G M P c t ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 G M P c t , 0 )   a s   P r e v M t h 2 G M P c t ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 G M P c t , 0 )   a s   P r e v M t h 3 G M P c t ,  
  
 	 	 	 I S N U L L ( C u s t W e b . Q t y S h i p p e d W e b , 0 )   A S   Q t y S h i p p e d W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . M a r g i n D o l l a r s W e b , 0 )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . M a r g i n P c t W e b , 0 )   A S   M a r g i n P c t W e b ,  
 	 	 	 C A S E   I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )  
 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	     E L S E   I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   /   C u s t A l l . S a l e s D o l l a r s   *   1 0 0  
 	 	 	       E N D   A S   W e b P c t S a l e s  
 	 	 F R O M 	 - - C u s t A l l  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 S U M ( L b s )   A S   L b s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   S U M ( S a l e s D o l l a r s )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 A R P o s t D t   > =   @ C u r M t h B e g   a n d   A R P o s t D t   < =   @ C u r E n d D a y  
 	 	 	   G R O U P   B Y   C u s t N o ,   C u s t N a m e )   C u s t A l l  
 	 	 L E F T   O U T E R   J O I N  
 	 	 	 - - C u s t W e b  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d W e b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t W e b  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 A R P o s t D t   > =   @ C u r M t h B e g   a n d   A R P o s t D t   < =   @ C u r E n d D a y   a n d   O r d e r S o u r c e S e q   =   1  
 	 	 	 	 - - O r d e r S o u r c e   I S   N O T   N U L L   a n d   O r d e r S o u r c e   < >   ' '   a n d   O r d e r S o u r c e   < >   ' M '  
 	 	 	   G R O U P   B Y   C u s t N o ,   C u s t N a m e )   C u s t W e b  
 	 	 O N 	 C u s t W e b . C u s t N o   =   C u s t A l l . C u s t N o  
 	 	 L E F T   O U T E R   J O I N  
 	 	 	 D a s h b o a r d C u s t S a l e s G o a l   D C S G  
 	 	 O N 	 D C S G . C u s t N o   =   C u s t A l l . C u s t N o  
  
 	 	 S E L E C T 	 ' - - R e p o r t   B   -   C u s t o m e r   S a l e s   O r d e r   L e v e l   ( A l l   L o c a t i o n s ) '  
 	       E N D  
       E N D  
 E L S E 	 	 	 - - S P E C I F I C   L O C A T I O N  
       B E G I N  
 	 - - I n v o i c e   L i n e   I t e m   D e t a i l   D r i l l d o w n  
 	 I F   @ C u s t N o   =   ' 0 0 0 0 0 0 '   A N D   @ I n v o i c e N o   =   ' 0 0 0 0 0 0 0 0 0 0 '  
 	       B E G I N  
 	 	 S E T 	 @ C u s t N o   =   ' ~ ~ ~ ~ ~ ~ '  
  
 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 C u s t N o ,  
 	 	 	 C u s t N a m e ,  
 	 	 	 I n v o i c e N o ,  
 	 	 	 L o c a t i o n ,  
 	 	 	 A r P o s t D t ,  
 	 	 	 O r d e r S o u r c e ,  
 	 	 	 O r d e r S o u r c e S e q ,  
 	 	 	 L i n e N u m b e r ,  
 	 	 	 I t e m N o ,  
 	 	 	 I S N U L L ( Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( M a r g i n P c t , 0 )   *   1 0 0   A S   M a r g i n P c t ,  
 	 	 	 I S N U L L ( M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 	 F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 W H E R E 	 L o c a t i o n   =   @ L o c   A N D   I t e m N o   I S   N O T   N U L L   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
  
 	 	 S E L E C T 	 ' - - I n v o i c e   L i n e   I t e m   D e t a i l   D r i l l d o w n   ( S P E C I F I C   L O C A T I O N :   '   +   @ L o c   +   ' ) '  
 	       E N D  
  
 	 - - R e p o r t   A   -   S a l e s   O r d e r   H e a d e r   L e v e l  
 	 I F   @ C u s t N o   =   ' * * * * * * '  
 	       B E G I N  
 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 O r d e r D t l . C u s t N o ,  
 	 	 	 O r d e r D t l . C u s t N a m e ,  
 	 	 	 O r d e r S u m . I n v o i c e N o ,  
 	 	 	 O r d e r D t l . L o c a t i o n ,  
 	 	 	 O r d e r D t l . A r P o s t D t ,  
 	 	 	 O r d e r D t l . O r d e r S o u r c e ,  
 	 	 	 O r d e r D t l . O r d e r S o u r c e S e q ,  
 	 	 	 I S N U L L ( O r d e r S u m . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( O r d e r S u m . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( O r d e r S u m . L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( O r d e r S u m . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 	 F R O M 	 ( S E L E C T 	 I n v o i c e N o ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 S U M ( L b s )   A S   L b s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   S U M ( S a l e s D o l l a r s )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 L o c a t i o n   =   @ L o c   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
 	 	 	   G R O U P   B Y   I n v o i c e N o )   O r d e r S u m  
 	 	 	 I N N E R   J O I N  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 I n v o i c e N o ,  
 	 	 	 	 L o c a t i o n ,  
 	 	 	 	 A r P o s t D t ,  
 	 	 	 	 O r d e r S o u r c e ,  
 	 	 	 	 O r d e r S o u r c e S e q  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 L o c a t i o n   =   @ L o c   A N D   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y )   O r d e r D t l  
 	 	 	 O N 	 O r d e r S u m . I n v o i c e N o   =   O r d e r D t l . I n v o i c e N o  
  
 	 	 S E L E C T 	 ' - - R e p o r t   A   -   S a l e s   O r d e r   H e a d e r   L e v e l   ( S P E C I F I C   L O C A T I O N :   '   +   @ L o c   +   ' ) '  
 	       E N D  
  
 	 - - R e p o r t   B   -   C u s t o m e r   S a l e s   O r d e r   L e v e l  
 	 I F   @ C u s t N o   =   ' 0 0 0 0 0 0 '  
 	       B E G I N  
 	 	 S E L E C T 	 C u s t A l l . C u s t N o ,  
 	 	 	 C u s t A l l . C u s t N a m e ,  
 	 	 	 I S N U L L ( C u s t A l l . Q t y S h i p p e d , 0 )   A S   Q t y S h i p p e d ,  
 	 	 	 I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 I S N U L L ( C u s t A l l . L b s , 0 )   A S   L b s ,  
 	 	 	 I S N U L L ( C u s t A l l . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b ,  
 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
  
 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   a s   M T D G o a l D o l ,  
 	 	 	 I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l G M P c t ,  
 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l M g n D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D S a l e s D o l , 0 )   a s   Y T D S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   a s   Y T D G o a l D o l ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l G M P c t ,  
 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l M g n D o l ,  
  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 S a l e s D o l , 0 )   a s   P r e v M t h 1 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 S a l e s D o l , 0 )   a s   P r e v M t h 2 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 S a l e s D o l , 0 )   a s   P r e v M t h 3 S a l e s D o l ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 G M P c t , 0 )   a s   P r e v M t h 1 G M P c t ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 G M P c t , 0 )   a s   P r e v M t h 2 G M P c t ,  
 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 G M P c t , 0 )   a s   P r e v M t h 3 G M P c t ,  
  
 	 	 	 I S N U L L ( C u s t W e b . Q t y S h i p p e d W e b , 0 )   A S   Q t y S h i p p e d W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . M a r g i n D o l l a r s W e b , 0 )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 I S N U L L ( C u s t W e b . M a r g i n P c t W e b , 0 )   A S   M a r g i n P c t W e b ,  
 	 	 	 C A S E   I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )  
 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	     E L S E   I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   /   C u s t A l l . S a l e s D o l l a r s   *   1 0 0  
 	 	 	       E N D   A S   W e b P c t S a l e s  
 	 	 F R O M 	 - - C u s t A l l  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 S U M ( L b s )   A S   L b s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   S U M ( S a l e s D o l l a r s )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 C A S E   S U M ( L B S )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( L b s )  
 	 	 	 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 L o c a t i o n   =   @ L o c   a n d   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y  
 	 	 	   G R O U P   B Y   C u s t N o ,   C u s t N a m e )   C u s t A l l  
 	 	 L E F T   O U T E R   J O I N  
 	 	 	 - - C u s t W e b  
 	 	 	 ( S E L E C T 	 C u s t N o ,  
 	 	 	 	 C u s t N a m e ,  
 	 	 	 	 S U M ( Q t y S h i p p e d )   A S   Q t y S h i p p e d W e b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 	 S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 	 C A S E   S U M ( S a l e s D o l l a r s )  
 	 	 	 	       W H E N   0   T H E N   0  
 	 	 	 	 	     E L S E   ( ( S U M ( S a l e s D o l l a r s )   -   S U M ( C o s t ) )   /   S U M ( S a l e s D o l l a r s ) )   *   1 0 0  
 	 	 	 	 E N D   A S   M a r g i n P c t W e b  
 	 	 	   F R O M 	 D a s h b o a r d C u s t I n v D a i l y  
 	 	 	   W H E R E 	 L o c a t i o n   =   @ L o c   a n d   A R P o s t D t   > =   @ C u r M t h B e g   A N D   A R P o s t D t   < =   @ C u r E n d D a y   a n d   L o c a t i o n   =   @ L o c   a n d   O r d e r S o u r c e S e q   =   1  
 	 	 	 	 - - O r d e r S o u r c e   I S   N O T   N U L L   a n d   O r d e r S o u r c e   < >   ' '   a n d   O r d e r S o u r c e   < >   ' M '  
 	 	 	   G R O U P   B Y   C u s t N o ,   C u s t N a m e )   C u s t W e b  
 	 	 O N 	 C u s t A l l . C u s t N o   =   C u s t W e b . C u s t N o  
 	 	 L E F T   O U T E R   J O I N  
 	 	 	 D a s h b o a r d C u s t S a l e s G o a l   D C S G  
 	 	 O N 	 D C S G . C u s t N o   =   C u s t A l l . C u s t N o  
  
 	 	 S E L E C T 	 ' - - R e p o r t   B   -   C u s t o m e r   S a l e s   O r d e r   L e v e l   ( S P E C I F I C   L O C A T I O N :   '   +   @ L o c   +   ' ) '  
 	       E N D  
       E N D  
 