U S E   [ D E V P E R P ]  
 G O  
 / * * * * * *   O b j e c t :     S t o r e d P r o c e d u r e   [ d b o ] . [ p S O E C r e a t e C A f o r E R P O r d e r ]         S c r i p t   D a t e :   0 4 / 2 2 / 2 0 1 0   1 6 : 4 2 : 4 5   * * * * * * /  
 S E T   A N S I _ N U L L S   O N  
 G O  
 S E T   Q U O T E D _ I D E N T I F I E R   O N  
 G O  
 
 
 
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p S O E C r e a t e C A f o r E R P O r d e r ]    
 	 - -   A d d   t h e   p a r a m e t e r s   f o r   t h e   s t o r e d   p r o c e d u r e   h e r e  
 	 @ o r d e r N o   B I G I N T   =   0  
 A S  
 B E G I N  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 - -   A u t h o r : 	 	 C r a i g   P a r k s  
 - -   C r e a t e   d a t e :   8 / 1 2 / 2 0 0 9  
 - -   D e s c r i p t i o n : 	 C r e a t e   R B   A d j u s t m e n t s   t o   S h i p   E R P   O r d e r s  
 - -   P a r a m e t e r s :   @ o r d e r N o   =   O r d e r   n u m b e r   o f   E R P   o r d e r   t o   s h i p  
 - -   M o d i f i e d :   3 / 2 5 / 2 0 1 0   C r a i g   P a r k s   S h i p   o n l y   a v a i l a b l e   r e c o r d   r e m a i n t e r   i n   S a l e s   b i n  
 - -   = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 - -   S E T   N O C O U N T   O N   a d d e d   t o   p r e v e n t   e x t r a   r e s u l t   s e t s   f r o m  
 	 - -   i n t e r f e r i n g   w i t h   S E L E C T   s t a t e m e n t s .  
 / *  
 	 E X E C   [ p S O E C r e a t e C A f o r E R P O r d e r ]   @ o r d e r N o = 2 0 7 2 7  
 * /  
 S E T   N O C O U N T   O N ;  
  
 S E L E C T 	 f S O H e a d e r R e l I D   A S   S t k I D ,  
 	 S O D R . I t e m N o ,  
 	 L I N E N U M B E R   A S   [ L i n e N o ] ,  
 	 I S N U L L ( B L A . L O C A T I O N , I M L o c )   A S   L o c a t i o n ,  
 	 I S N U L L ( S U M   ( I S N U L L ( Q U A N T I T Y , 0 )   *   I S N U L L ( P A C K S I Z E , 0 ) ) , 0 )   A S   O n H a n d R B ,  
 	 S U M ( Q t y S h i p p e d )   A S   R e q u e s t e d  
 I N T O 	 # O N H a n d R B  
 F R O M 	 S o D e t a i l R e l   S O D R   ( N O L O C K )   L E F T   O U T E R   J O I N    
 	 O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . [ B I N L O C A T ]   B L A  
 O N 	 S O D R . I t e m N o   =   B L A . P R O D U C T   A N D   S O D R . I M L o c   =   B L A . L O C A T I O N   a n d   B L A . B I N L A B E L   =   S O D R . I M L o c + ' S T K ' + S O D R . I M L o c  
 W H E R E 	 f S O H e a d e r R e l I D   =   @ O r d e r N o  
 G R O U P   B Y   f S O H e a d e r R e l I D ,   S O D R . I t e m N o ,   L i n e N u m b e r ,   I S N U L L ( B L A . L O C A T I O N , I M L o c )  
  
  
 - - P R I N T   ' O r d e r   ' + C A S T ( @ o r d e r N o   a s   V A R C H A R )  
 - - S E L E C T   *   F R O M   # O N H a n d R B  
  
  
 I N S E R T   I N T O   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . [ D N L O A D ]  
 	 ( F I E L D 0 0 1 ,   F I E L D 0 0 2 , F I E L D 0 0 3 , F I E L D 0 0 4 ,   F I E L D 0 0 5 ,   F I E L D 0 0 6 ,   F I E L D 0 0 7 ,   F I E L D 0 0 8 ,   F I E L D 0 0 9 ,   F I E L D 0 1 0 ,   F I E L D 0 1 1 ,  
 	   F I E L D 0 1 2 ,   F I E L D 0 1 3 ,   F I E L D 0 1 4 ,   F I E L D 0 1 5 ,   F I E L D 0 1 6 ,   F I E L D 0 1 7 ,   F I E L D 0 1 8 ,   F I E L D 0 1 9 ,   F I E L D 0 2 0 ,   F I E L D 0 2 1 ,   F I E L D 0 2 2 ,  
 	   F I E L D 0 2 3 ,   F I E L D 0 2 4 ,   F I E L D 0 2 5 ,   F I E L D 0 2 6 ,   F I E L D 0 2 7 ,   F I E L D 0 2 8 ,   F I E L D 0 2 9 ,   F I E L D 0 3 0 ,   F I E L D 0 3 1 )  
 S E L E C T 	 ' C A '   a s   [ T y p e ] ,  
 	 ' M A '   A S   A d j T y p e ,  
 	 S O D . I t e m N o ,  
 	 L e f t ( I t e m D s c , 4 0 )   A S   I t e m D s c ,  
 	 1   a s   U M ,  
 	 N U L L   A S   P r o d C l s ,  
 	 I M . U P C C d ,    
 	 C A S E   W H E N   Q t y S h i p p e d   < =   O n H a n d R B  
 	           T H E N   C A S T ( C A S T ( Q t y S h i p p e d   A S   I N T )   A S   V A R C H A R )    
 	           E L S E   C A S T ( C A S T ( O n H a n d R B   A S   I N T )   A S   V A R C H A R )  
 	 E N D   A S   T o R e c e i v e ,  
 	 ' 1 '   A S   P a c k s i z e ,  
 	 ' - '   A S   Q t y S i g n ,  
 	 S O D . I M L o c + ' S T K ' + S O D . I M L o c   A s   P i c k B i n ,  
 	 N U L L   A S   r e s S t o c k F l a g ,  
 	 C A S T ( O r d e r N o   A S   V A R C H A R )   a s   P O N o ,  
 	 N U L L   A S   C o m m e n t ,  
 	 ' '   A S   a t t r 1 ,  
 	 ' '   A S   a t t r 2 ,  
 	 ' '   A S   a t t r 3 ,  
 	 ' '   A S   a t t r 4 ,  
 	 ' '   A S   a t t r 5 ,  
 	 ' '   A S   a t t r 6 ,  
 	 ' '   A S   a t t r 7 ,  
 	 ' '   A S   a t t r 8 ,  
 	 ' '   A S   a t t r 9 ,  
 	 ' '   A S   a t t r 1 0 ,  
 	 ' 0 0 0 0 0 0 0 0 0 0 '   A S   R c v A t t r ,  
 	 ' '   A S   E x p e c t e d R e c D t ,  
 	 N U L L   A S   C l i e n t N a m e ,  
 	 N U L L   A S   I n n e r P a c k ,  
 	 N U L L   A S   M i n R e p l ,  
 	 N U L L   A S   M a x R e p l ,  
 	 N U L L   A S   L i c e n s e P l a t e  
 F R O M 	 S O H e a d e r R e l   ( N O L O C K )   S O H   J O I N   S O D e t a i l R e l   ( N O L O C K )   S O D  
 O N 	 p S O H e a d e r R e l I D   =   f S O H e a d e r R e l I D ,  
 	 I t e m M a s t e r   ( N O L O C K )   I M ,   # O N H a n d R B    
 W H E R E 	 O r d e r N o   =   @ O r d e r N o   A N D   S O D . I t e m N o   =   I M . I t e m N o   A N D   S t k I D   =   f S O H e a d e r R e l I D   A N D  
 	 S O D . I t e m N o   =   # O N H a n d R B . I t e m N o   A N D   L i n e N u m b e r   =   [ L i n e N o ]   A N D  
 	 C A S E   W H E N   Q t y S h i p p e d   < =   O n H a n d R B  
 	           T H E N   C A S T ( C A S T ( Q t y S h i p p e d   A S   I N T )   A S   V A R C H A R )    
 	           E L S E   C A S T ( C A S T ( O n H a n d R B   A S   I N T )   A S   V A R C H A R )  
 	 E N D   >   0  
  
  
 I N S E R T   I N T O   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . [ D N L O A D ]  
 	 ( F I E L D 0 0 1 ,   F I E L D 0 0 2 , F I E L D 0 0 3 , F I E L D 0 0 4 ,   F I E L D 0 0 5 ,   F I E L D 0 0 6 ,   F I E L D 0 0 7 ,   F I E L D 0 0 8 ,   F I E L D 0 0 9 ,   F I E L D 0 1 0 ,   F I E L D 0 1 1 ,  
 	   F I E L D 0 1 2 ,   F I E L D 0 1 3 ,   F I E L D 0 1 4 ,   F I E L D 0 1 5 ,   F I E L D 0 1 6 ,   F I E L D 0 1 7 ,   F I E L D 0 1 8 ,   F I E L D 0 1 9 ,  
 	   F I E L D 0 2 0 ,   F I E L D 0 2 1 ,   F I E L D 0 2 2 ,   F I E L D 0 2 3 ,   F I E L D 0 2 4 ,   F I E L D 0 2 5 ,   F I E L D 0 2 6 ,   F I E L D 0 2 7 ,   F I E L D 0 2 8 ,   F I E L D 0 2 9 ,  
 	   F I E L D 0 3 0 ,   F I E L D 0 3 1 )  
 S E L E C T 	 ' C A '   a s   [ T y p e ] ,  
 	 ' M A '   A S   A d j T y p e ,  
 	 S O D . I t e m N o ,  
 	 L e f t ( I t e m D s c , 4 0 )   A S   I t e m D s c ,  
 	 1   a s   U M ,  
 	 N U L L   A S   P r o d C l s ,  
 	 I M . U P C C d ,    
 	 C A S T ( C A S T ( ( Q t y S h i p p e d   -   O n H a n d R B )   A S   I N T )   A S   V A R C H A R )   A S   S O L D ,  
 	 ' 1 '   A S   P a c k s i z e ,   ' + '   A S   Q t y S i g n ,  
 	 S O D . I M L o c + ' S A L E ' + S O D . I M L o c   A s   P i c k B i n ,  
 	 N U L L   A S   r e s S t o c k F l a g ,  
 	 C A S T ( O r d e r N o   A S   V A R C H A R )   a s   P O N o ,  
 	 N U L L   A S   C o m m e n t ,  
 	 ' '   A S   a t t r 1 ,  
 	 ' '   A S   a t t r 2 ,  
 	 ' '   A S   a t t r 3 ,  
 	 ' '   A S   a t t r 4 ,  
 	 ' '   A S   a t t r 5 ,  
 	 ' '   A S   a t t r 6 ,  
 	 ' '   A S   a t t r 7 ,  
 	 ' '   A S   a t t r 8 ,  
 	 ' '   A S   a t t r 9 ,  
 	 ' '   A S   a t t r 1 0 ,  
 	 ' 0 0 0 0 0 0 0 0 0 0 '   A S   R c v A t t r ,  
 	 ' '   A S   E x p e c t e d R e c D t ,  
 	 N U L L   A S   C l i e n t N a m e ,  
 	 N U L L   A S   I n n e r P a c k ,  
 	 N U L L   A S   M i n R e p l ,  
 	 N U L L   A S   M a x R e p l ,  
 	 ' S A L E : ' + C A S T ( S t k I D   A S   V A R C H A R )   A S   L i c e n s e P l a t e  
 F R O M 	 S O H e a d e r R e l   ( N O L O C K )   S O H   J O I N   S O D e t a i l R e l   ( N O L O C K )   S O D  
 O N   	 p S O H e a d e r R e l I D   =   f S O H e a d e r R e l I D ,  
 	 I t e m M a s t e r   ( N O L O C K )   I M ,   # O N H a n d R B    
 W H E R E 	 O r d e r N o   =   @ O r d e r N o   A N D   S O D . I t e m N o   =   I M . I t e m N o     A N D   S t k I D   =   f S O H e a d e r R e l I D   A N D  
 	 # O N H a n d R B . I t e m N o   =   S O D . I t e m N o   A N D   L i n e N u m b e r   =   [ L i n e N o ]   A N D   ( Q t y S h i p p e d   -   O n H a n d R B )   >   0  
  
 D R O P   t a b l e   # O N H a n d R B  
  
 E N D  
 