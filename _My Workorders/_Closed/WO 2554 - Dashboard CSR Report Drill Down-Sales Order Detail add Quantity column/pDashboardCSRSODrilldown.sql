C R E A T E   p r o c e d u r e   [ d b o ] . [ p D a s h b o a r d C S R S O D r i l l d o w n ]  
 @ L o c   v a r c h a r ( 2 0 ) ,  
 @ C u s t N o   v a r c h a r ( 2 0 ) ,  
 @ I n v o i c e N o   v a r c h a r ( 2 0 ) ,  
 @ c s r N a m e   v a r c h a r ( 2 0 ) ,  
 @ p e r i o d   v a r c h a r ( 2 0 ) ,   - -   M T D / D a i l y  
 @ r e p o r t T y p e   v a r c h a r ( 1 0 )   - -   H e a d e r / D e t a i l  
 a s  
  
 - - - - [ p D a s h b o a r d C S R S O D r i l l d o w n D a i l y ]  
 - - - - W r i t t e n   B y :   S a t h i s h  
 - - - - A p p l i c a t i o n :   C S R   p e r f o r m a n c e   r e p o r t  
  
 D e c l a r e 	 @ C u r D a y 	 	 d a t e t i m e 	 - - C u r r e n t   D a s h B o a r d   D a t e  
 D e c l a r e 	 @ C u r E n d D a y 	 d a t e t i m e 	 - - C u r r e n t   D a s h B o a r d   E n d   D a t e  
  
 	 I f   @ p e r i o d   =   ' D a i l y '  
 	 B e g i n  
 	 	 S e t 	 @ C u r d a y   =   ( S E L E C T   B e g D a t e   F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C S Q L t ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P F C R e p o r t s . d b o . D a s h B o a r d R a n g e s   W H E R E   D a s h B o a r d P a r a m e t e r   =   ' C u r r e n t D a y ' )  
 	 	 S e t 	 @ C u r E n d D a y   =   ( S E L E C T   E n d D a t e   F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C S Q L t ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P F C R e p o r t s . d b o . D a s h B o a r d R a n g e s   W H E R E   D a s h B o a r d P a r a m e t e r   =   ' C u r r e n t D a y ' )  
 	 E n d  
 	 E l s e   I f   @ p e r i o d   =   ' M T D '  
 	 B e g i n  
 	 	 S e l e c t 	 @ C u r d a y = B e g D a t e , @ C u r E n d D a y = E n d D a t e    
 	 	 F r o m 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C S Q L t ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . P F C R e p o r t s . d b o . D a s h b o a r d R a n g e s 	  
 	 	 W h e r e 	 D a s h b o a r d P a r a m e t e r = ' C u r r e n t M o n t h '  
 	 E n d  
 	 - - S E L E C T 	 @ C u r D a y   a s   C u r D a y ,   @ C u r E n d D a y   a s   C u r E n d D a y  
  
 	 - -   G e t   d a t a   f o r   #   o r d e r   r o w   i n   C S R   p e r f o r m a n c e   r e p o r t  
 	 I f ( @ r e p o r t T y p e   =   ' H e a d e r ' )    
 	 	 B e g i n  
 	 	 	 - -   S a l e s   O r d e r   H e a d e r   B y   I n v o i c e  
 	 	 	 I F   @ C u s t N o   =   ' * * * * * * '  
 	 	 	 	 B E G I N  
 	 	 	 	  
 	 	 	 	 S E L E C T 	 D I S T I N C T  
 	 	 	 	 	 	 O r d e r D t l . C u s t N o ,  
 	 	 	 	 	 	 O r d e r D t l . C u s t N a m e ,  
 	 	 	 	 	 	 O r d e r S u m . I n v o i c e N o ,  
 	 	 	 	 	 	 O r d e r D t l . L o c a t i o n ,  
 	 	 	 	 	 	 O r d e r D t l . A r P o s t D t ,  
 	 	 	 	 	 	 O r d e r D t l . O r d e r S o u r c e , 	 	 	  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . L b s , 0 )   A S   L b s ,  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
 	 	 	 	 	 	 I S N U L L ( O r d e r S u m . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b  
 	 	 	 	 F R O M 	 (  
 	 	 	 	 	 	 	 S E L E C T 	 I n v o i c e N o ,  
 	 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 	 	 	 	 	 S U M ( S h i p W g h t )   A S   L b s ,  
 	 	 	 	 	 	 	 	 	 C A S E   S U M ( S h i p W g h t )   W H E N   0   T H E N   0   E L S E   S U M ( N e t S a l e s )   /   S U M ( S h i p W g h t )   E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 	 	 	 	 	 C A S E   S U M ( S h i p W g h t )   W H E N   0   T H E N   0   E L S E   ( S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t ) )   /   S U M ( S h i p W g h t ) 	 E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 	 	 	 	 	 C A S E   S U M ( N e t S a l e s )   W H E N   0   T H E N   0   E L S E   ( ( S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t ) )   /   S U M ( N e t S a l e s ) )   *   1 0 0   E N D   A S   M a r g i n P c t  
 	 	 	 	 	 	 	 F R O M 	 S O H e a d e r H i s t   ( N O L O C K )  
 	 	 	 	 	 	 	 W H E R E 	 ( I n v o i c e D t   b e t w e e n   @ C u r D a y   a n d   @ C u r E n d D a y )  
 	 	 	 	 	 	 	 	 	 a n d   D e l e t e D t   i s   n u l l  
 	 	 	 	 	 	 	 	 	 a n d   S e l l T o C u s t N o   i n  
 	 	 	 	 	 	 	 	 	 	 ( 	 s e l e c t 	 C u s t N o 	  
 	 	 	 	 	 	 	 	 	 	 	 f r o m 	 C u s t o m e r M a s t e r   ( N O L O C K )   C M   L e f t   O u t e r   J o i n    
 	 	 	 	 	 	 	 	 	 	 	 	 	 R e p M a s t e r   ( N O L O C K )   R M  
 	 	 	 	 	 	 	 	 	 	 	 	 	 O n   C M . S u p p o r t R e p N o   =   R M . R e p N o 	 	 	 	 	 	  
 	 	 	 	 	 	 	 	 	 	 	 W h e r e 	 R M . R e p N o t e s   l i k e   @ c s r N a m e )  
 	 	 	 	 	 	 	   G R O U P   B Y   I n v o i c e N o  
 	 	 	 	 	 	 )   O r d e r S u m  
 	 	 	 	 	 I N N E R   J O I N  
 	 	 	 	 	 (  
 	 	 	 	 	 	 S E L E C T 	 S e l l T o C u s t N o   a s   C u s t N o ,  
 	 	 	 	 	 	 	 	 S e l l T o C u s t N a m e   a s   C u s t N a m e ,  
 	 	 	 	 	 	 	 	 I n v o i c e N o ,  
 	 	 	 	 	 	 	 	 C u s t S h i p L o c   a s   L o c a t i o n ,  
 	 	 	 	 	 	 	 	 I n v o i c e D t   a s   A r P o s t D t ,  
 	 	 	 	 	 	 	 	 O r d e r S o u r c e  
 	 	 	 	 	 	 F R O M 	 S O H e a d e r H i s t   ( N O L O C K )  
 	 	 	 	 	 	 W H E R E 	 ( I n v o i c e D t   b e t w e e n   @ C u r D a y   a n d   @ C u r E n d D a y )  
 	 	 	 	 	 	 	 	 a n d   D e l e t e D t   i s   n u l l  
 	 	 	 	 	 	 	 	 a n d   S e l l T o C u s t N o   i n  
 	 	 	 	 	 	 	 	 ( 	 S e l e c t 	 C u s t N o 	  
 	 	 	 	 	 	 	 	 	 F r o m 	 C u s t o m e r M a s t e r   ( N O L O C K )   C M   L e f t   O u t e r   J o i n    
 	 	 	 	 	 	 	 	 	 	 	 R e p M a s t e r   ( N O L O C K )   R M  
 	 	 	 	 	 	 	 	 	 	 	 O n   C M . S u p p o r t R e p N o   =   R M . R e p N o 	 	 	 	 	 	  
 	 	 	 	 	 	 	 	 	 W h e r e 	 R M . R e p N o t e s   l i k e   @ c s r N a m e   )  
 	 	 	 	 	 )   O r d e r D t l  
 	 	 	 	 	 O N 	 O r d e r S u m . I n v o i c e N o   =   O r d e r D t l . I n v o i c e N o  
  
 	 	 	       E N D  
  
 	 	 	 - -   S a l e s   O r d e r   H e a d e r   B y   C u s t o m e r  
 	 	 	 I F   @ C u s t N o   =   ' 0 0 0 0 0 0 '  
 	 	 	       B E G I N  
 	 	 	 	 S E L E C T 	 C u s t A l l . C u s t N o ,  
 	 	 	 	 	 	 C u s t A l l . C u s t N a m e ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . L b s , 0 )   A S   L b s ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . S a l e s P e r L b , 0 )   A S   S a l e s P e r L b ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . M a r g i n D o l l a r s , 0 )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P e r L b , 0 )   A S   M a r g i n P e r L b ,  
 	 	 	 	 	 	 I S N U L L ( C u s t A l l . M a r g i n P c t , 0 )   A S   M a r g i n P c t ,  
  
 	 	 	 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   a s   M T D G o a l D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l G M P c t ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . M T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . M T D G o a l G M P c t , 0 )   a s   M T D G o a l M g n D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . Y T D S a l e s D o l , 0 )   a s   Y T D S a l e s D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   a s   Y T D G o a l D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l G M P c t ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . Y T D G o a l D o l , 0 )   *   I S N U L L ( D C S G . Y T D G o a l G M P c t , 0 )   a s   Y T D G o a l M g n D o l ,  
  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 S a l e s D o l , 0 )   a s   P r e v M t h 1 S a l e s D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 S a l e s D o l , 0 )   a s   P r e v M t h 2 S a l e s D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 S a l e s D o l , 0 )   a s   P r e v M t h 3 S a l e s D o l ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 1 G M P c t , 0 )   a s   P r e v M t h 1 G M P c t ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 2 G M P c t , 0 )   a s   P r e v M t h 2 G M P c t ,  
 	 	 	 	 	 	 I S N U L L ( D C S G . P r e v M t h 3 G M P c t , 0 )   a s   P r e v M t h 3 G M P c t ,  
  
 	 	 	 	 	 	 I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 	 	 	 I S N U L L ( C u s t W e b . M a r g i n D o l l a r s W e b , 0 )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 	 	 	 I S N U L L ( C u s t W e b . M a r g i n P c t W e b , 0 )   A S   M a r g i n P c t W e b ,  
 	 	 	 	 	 	 C A S E   I S N U L L ( C u s t A l l . S a l e s D o l l a r s , 0 )   W H E N   0   T H E N   0   E L S E   I S N U L L ( C u s t W e b . S a l e s D o l l a r s W e b , 0 )   /   C u s t A l l . S a l e s D o l l a r s   *   1 0 0   E N D   A S   W e b P c t S a l e s  
 	 	 	 	 F R O M 	 - - C u s t A l l  
 	 	 	 	 	 	 ( S E L E C T 	 S e l l T o C u s t N o   a s   C u s t N o ,  
 	 	 	 	 	 	 	 	 S e l l T o C u s t N a m e   a s   C u s t N a m e ,  
 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   A S   S a l e s D o l l a r s ,  
 	 	 	 	 	 	 	 	 S U M ( S h i p W g h t )   A S   L b s ,  
 	 	 	 	 	 	 	 	 C A S E   S U M ( S h i p W g h t )   W H E N   0   T H E N   0   E L S E   S U M ( N e t S a l e s )   /   S U M ( S h i p W g h t )   E N D   A S   S a l e s P e r L b ,  
 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t )   A S   M a r g i n D o l l a r s ,  
 	 	 	 	 	 	 	 	 C A S E   S U M ( S h i p W g h t )   W H E N   0   T H E N   0   E L S E   ( S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t ) )   /   S U M ( S h i p W g h t )   E N D   A S   M a r g i n P e r L b ,  
 	 	 	 	 	 	 	 	 C A S E   S U M ( N e t S a l e s )   W H E N   0   T H E N   0   E L S E   ( ( S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t ) )   /   S U M ( N e t S a l e s ) )   *   1 0 0   E N D   A S   M a r g i n P c t  
 	 	 	 	 	 	   F R O M 	 S O H e a d e r H i s t   ( N O L O C K )  
 	 	 	 	 	 	   W H E R E 	 ( I n v o i c e D t   b e t w e e n   @ C u r D a y   a n d   @ C u r E n d D a y )   A N D   D e l e t e D t   i s   n u l l  
 	 	 	 	 	 	 	 	 a n d   S e l l T o C u s t N o   i n   ( S E L E C T 	 C u s t N o 	  
 	 	 	 	 	 	 	 	 	 	 	 	 	   F R O M 	 C u s t o m e r M a s t e r   ( N O L O C K )   C M   L e f t   O u t e r   J o i n    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 R e p M a s t e r   ( N O L O C K )   R M  
 	 	 	 	 	 	 	 	 	 	 	 	 	   O N 	 	 C M . S u p p o r t R e p N o   =   R M . R e p N o 	 	 	 	 	 	  
 	 	 	 	 	 	 	 	 	 	 	 	 	   W H E R E 	 R M . R e p N o t e s   l i k e   @ c s r N a m e )  
 	 	 	 	 	 	   G R O U P   B Y   S e l l T o C u s t N o ,   S e l l T o C u s t N a m e )   C u s t A l l  
 	 	 	 	 L E F T   O U T E R   J O I N  
 	 	 	 	 	 	 - - C u s t W e b  
 	 	 	 	 	 	 ( S E L E C T 	 S e l l T o C u s t N o   a s   C u s t N o ,  
 	 	 	 	 	 	 	 	 S e l l T o C u s t N a m e   a s   C u s t N a m e ,  
 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   A S   S a l e s D o l l a r s W e b ,  
 	 	 	 	 	 	 	 	 S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t )   A S   M a r g i n D o l l a r s W e b ,  
 	 	 	 	 	 	 	 	 C A S E   S U M ( N e t S a l e s )   W H E N   0   T H E N   0   E L S E   ( ( S U M ( N e t S a l e s )   -   S U M ( T o t a l C o s t ) )   /   S U M ( N e t S a l e s ) )   *   1 0 0   E N D   A S   M a r g i n P c t W e b  
 	 	 	 	 	 	   F R O M 	 S O H e a d e r H i s t   ( N O L O C K )  
 	 	 	 	 	 	   W H E R E 	 ( I n v o i c e D t   b e t w e e n   @ C u r D a y   a n d   @ C u r E n d D a y )   A N D   D e l e t e D t   i s   n u l l  
 	 	 	 	 	 	 	 	 a n d   O r d e r S o u r c e   I n   ( ' D C ' , ' I X ' , ' W Q ' , ' F P ' , ' E I ' )    
 	 	 	 	 	 	 	 	 a n d   S e l l T o C u s t N o   i n   ( S E L E C T 	 C u s t N o 	  
 	 	 	 	 	 	 	 	 	 	 	 	 	   F R O M 	 C u s t o m e r M a s t e r   ( N O L O C K )   C M   L e f t   O u t e r   J o i n    
 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 R e p M a s t e r   ( N O L O C K )   R M  
 	 	 	 	 	 	 	 	 	 	 	 	 	   O N 	 	 C M . S u p p o r t R e p N o   =   R M . R e p N o 	 	 	 	 	 	  
 	 	 	 	 	 	 	 	 	 	 	 	 	   W H E R E 	 R M . R e p N o t e s   l i k e   @ c s r N a m e ) 	 	 	 	 	  
 	 	 	 	 	 	   G R O U P   B Y   S e l l T o C u s t N o ,   S e l l T o C u s t N a m e )   C u s t W e b  
 	 	 	 	 O N 	 	 C u s t A l l . C u s t N o   =   C u s t W e b . C u s t N o  
 	 	 	 	 L E F T   O U T E R   J O I N  
 	 	 	 	 	 	 D a s h b o a r d C u s t S a l e s G o a l   D C S G  
 	 	 	 	 O N 	 	 D C S G . C u s t N o   =   C u s t A l l . C u s t N o  
  
 s e l e c t   ' S a l e s   O r d e r   H e a d e r   B y   C u s t o m e r '  
  
 	 	 	       E N D  
 	 	 E N D  
 	 I f ( @ r e p o r t T y p e   =   ' D e t a i l ' )    
 	 	 B e g i n 	 	 	  
 	 	 	 S E L E C T 	 S O H . S e l l T o C u s t N o   a s   C u s t N o  
 	 	 	 	 	 , S O H . S e l l T o C u s t N a m e   a s   C u s t N a m e  
 	 	 	 	 	 , S O H . I n v o i c e N o  
 	 	 	 	 	 , S O H . C u s t S h i p L o c   a s   L o c a t i o n  
 	 	 	 	 	 , S O H . A r P o s t D t  
 	 	 	 	 	 , S O H . O r d e r S o u r c e  
 	 	 	 	 	 , S O D . L i n e N u m b e r  
 	 	 	 	 	 , S O D . I t e m N o  
 	 	 	 	 	 , S O D . Q t y S h i p p e d  
 	 	 	 	 	 , I S N U L L ( E x t e n d e d P r i c e , 0 )   A S   S a l e s D o l l a r s  
 	 	 	 	 	 , I S N U L L ( E x t e n d e d N e t W g h t , 0 )   A S   L b s 	 	  
 	 	 	 	 	 , C a s t ( ( i s n u l l ( C a s e   w h e n   E x t e n d e d N e t W g h t   =   0   t h e n   0     e l s e   (   E x t e n d e d P r i c e   /   E x t e n d e d N e t W g h t   )   E n d , 0 ) )   a s   D e c i m a l ( 1 8 , 2 ) )     a s   S a l e s P e r L b  
 	 	 	 	 	 , C a s t ( i s n u l l ( ( E x t e n d e d P r i c e   -   E x t e n d e d C o s t ) , 0 )   a s   D e c i m a l ( 1 8 , 2 ) )   a s   M a r g i n D o l l a r s  
 	 	 	 	 	 , C a s t ( ( i s n u l l ( C a s e   w h e n   E x t e n d e d P r i c e   =   0   t h e n   0     e l s e   ( ( ( E x t e n d e d P r i c e - E x t e n d e d C o s t )   / E x t e n d e d P r i c e )   *   1 0 0 )   E n d , 0 )   )   a s   D e c i m a l ( 1 8 , 2 ) )   a s   M a r g i n P c t  
 	 	 	 	 	 , C a s t ( ( C a s e   w h e n   E x t e n d e d N e t W g h t   =   0   t h e n   0     e l s e   ( ( E x t e n d e d P r i c e - E x t e n d e d C o s t ) / E x t e n d e d N e t W g h t )   E n d )     a s   D e c i m a l ( 1 8 , 2 ) )     a s   M a r g i n P e r L b  
 	 	 	 F R O M 	 S O D e t a i l H i s t   S O D   L e f t   O u t e r   J o i n   S O H e a d e r H i s t   S O H  
 	 	 	 	 	 O n     S O D . f S O H e a d e r H i s t I D   =   S O H . p S O H e a d e r H i s t I D  
 	 	 	 W H E R E 	 ( S O H . I n v o i c e D t   b e t w e e n   @ C u r D a y   a n d   @ C u r E n d D a y )  
 	 	 	 	 	 a n d   S O H . S e l l T o C u s t N o   i n  
 	 	 	 	 	 ( 	 S e l e c t 	 C u s t N o 	  
 	 	 	 	 	 	 F r o m 	 C u s t o m e r M a s t e r   ( N O L O C K )   C M   L e f t   O u t e r   J o i n    
 	 	 	 	 	 	 	 	 R e p M a s t e r   ( N O L O C K )   R M  
 	 	 	 	 	 	 	 	 O n   C M . S u p p o r t R e p N o   =   R M . R e p N o 	 	 	 	 	 	  
 	 	 	 	 	 	 W h e r e 	 R M . R e p N o t e s   l i k e   @ c s r N a m e   )  
 	 	 E n d  
  
 - -   E x e c   [ p D a s h b o a r d C S R S O D r i l l d o w n ]   ' 0 0 ' , ' 0 0 0 0 0 0 ' , ' * * * * * * * * * * ' , ' K V E S N E S K I ' , ' M T D '  
 