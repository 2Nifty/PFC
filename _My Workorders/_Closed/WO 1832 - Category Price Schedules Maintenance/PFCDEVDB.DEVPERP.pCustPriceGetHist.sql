C R E A T E   P r o c e d u r e   [ d b o ] . [ p C u s t P r i c e G e t H i s t ]  
 @ C u s t N o   v a r c h a r ( 2 0 )  
 a s  
 / *  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 A u t h o r : 	 	 T o m   S l a t e r  
 	 C r e a t e   d a t e :   3 / 1 5 / 2 0 1 0  
 	 D e s c r i p t i o n :   G e t   C u s t o m e r   P r i c e   H i s t o r y   f o r   C a t e g o r y   P r i c e   S c h e d u l e   M a i n t e n a n c e  
 	 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 	 D e r i v e d   f r o m   p W O 1 7 5 5 _ G e t C u s t D a t a   W r i t t e n   B y   C h a r l e s   R o j a s  
 	 C r e a t e   D a t e :   0 2 / 1 9 / 1 0  
  
 	 e x e c   p C u s t P r i c e G e t H i s t   ' 0 0 4 4 0 1 '  
 * /  
 B E G I N  
 d e c l a r e   @ R e c s F o u n d   B I G I N T ;  
 s e t   @ R e c s F o u n d   =   0 ;  
 - -   s e e   i f   t h e r e   a r e   a n y   a p p r o v a l   r e c o r d s   w a i t i n g  
 s e l e c t    
 	 @ R e c s F o u n d = c o u n t ( * )  
 f r o m   U n p r o c e s s e d C a t e g o r y P r i c e   w i t h   ( N O L O C K )  
 w h e r e   C u s t o m e r N o   =   @ C u s t N o ;  
  
 i f   i s n u l l ( @ R e c s F o u n d , 0 )   >   0  
 	 b e g i n  
  
 	 s e l e c t   *  
 	 	 , ' 1 '   a s   R e c T y p e  
 	 f r o m   U n p r o c e s s e d C a t e g o r y P r i c e   w i t h   ( N O L O C K )  
 	 w h e r e   C u s t o m e r N o   =   @ C u s t N o ;  
  
 	 S E L E C T 	 C u s t N o   a s   C u s t o m e r N o  
 	 	 	 , C u s t N a m e   a s   C u s t o m e r N a m e  
 	 	 	 , S h i p L o c a t i o n   a s   B r a n c h  
 	 	 	 , C r e d i t I n d  
 	 	 	 , C o n t r a c t S c h d 1  
 	 	 	 , C o n t r a c t S c h d 2  
 	 	 	 , C o n t r a c t S c h d 3  
 	 	 	 , C o n t r a c t S c h e d u l e 4  
 	 	 	 , C o n t r a c t S c h e d u l e 5  
 	 	 	 , C o n t r a c t S c h e d u l e 6  
 	 	 	 , C o n t r a c t S c h e d u l e 7  
 	 	 	 , T a r g e t G r o s s M a r g i n P c t  
 	 	 	 , W e b D i s c o u n t P c t  
 	 	 	 , W e b D i s c o u n t I n d  
 	 	 	 , ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D = f L i s t M a s t e r I D   W H E R E   L i s t N a m e = ' C u s t D e f P r i c e S c h d ' )   L D  
 	 	 	 	   O N   L D . L i s t V a l u e = C u s t o m e r D e f a u l t P r i c e   W H E R E   C u s t N o = @ C u s t N o )   a s   C u s t o m e r D e f a u l t P r i c e  
 	 	 	 , ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D = f L i s t M a s t e r I D   W H E R E   L i s t N a m e = ' C u s t P r i c e I n d ' )   L D  
 	 	 	 	   O N   L D . L i s t V a l u e = C u s t o m e r P r i c e I n d   W H E R E   C u s t N o = @ C u s t N o )   a s   C u s t o m e r P r i c e I n d  
 	 F R O M 	 C u s t o m e r M a s t e r   C M   ( N o l o c k )    
 	 W H E R E 	 C M . C u s t N o = @ C u s t N o ; 	  
  
 	 e n d  
 e l s e  
 	 b e g i n  
 	 S E L E C T 	 t m p 2 . B r a n c h  
 	 	 , t m p 2 . C u s t N o   a s   C u s t o m e r N o  
 	 	 , t m p 2 . C u s t N a m e   a s   C u s t o m e r N a m e  
 	 	 , t m p 2 . G r o u p N o  
 	 	 , t m p 2 . G r o u p D e s c  
 	 	 , t m p 2 . G r o u p S a l e s   a s   S a l e s H i s t o r y  
 	 	 , r o u n d ( t m p 2 . P r i c e C o s t G M P c t , 2 )   a s   G M P c t P r i c e C o s t  
 	 	 , 0 . 0   a s   T a r g e t G M P c t  
 	 	 , ' 0 '   a s   A p p r o v e d  
 	 	 , ' 0 '   a s   R e c T y p e  
 	 	 , - 1   a s   p U n p r o c e s s e d C a t e g o r y P r i c e I D  
 	 	 , E x i s t i n g C u s t P r i c e P c t  
 	 F R O M  
 	 	 ( S E L E C T   C u s t N o  
 	 	 	 , C u s t N a m e  
 	 	 	 , B r a n c h  
 	 	 	 , L i s t V a l u e   a s   G r o u p N o  
 	 	 	 , L i s t D t l D e s c   a s   G r o u p D e s c  
 	 	 	 , i s n u l l ( s u m ( S a l e s ) , 0 )   a s   G r o u p S a l e s  
 	 	 	 , C a s e   w h e n   S u m ( S a l e s )   =   0   t h e n   0    
 	 	 	 	 e l s e   1 0 0 * S u m ( P r i c e G M D o l ) / s u m ( S a l e s )   e n d   a s   P r i c e C o s t G M P c t  
 	 	 	 , m a x ( i s n u l l ( E x i s t i n g C u s t P r i c e P c t , - 1 ) )   a s   E x i s t i n g C u s t P r i c e P c t  
 	 	 F r o m  
 	 	 	 ( S E L E C T 	 S O H . A R P o s t D t    
 	 	 	 	 , S O H . S e l l T o C u s t N o   a s   C u s t N o    
 	 	 	 	 , C M . C u s t S h i p L o c a t i o n   a s   B r a n c h  
 	 	 	 	 , S O H . S e l l T o C u s t N a m e   a s   C u s t N a m e    
 	 	 	 	 , S O D . I t e m N o    
 	 	 	 	 , C A S . G r o u p N o   a s   L i s t V a l u e  
 	 	 	 	 , C A S . D e s c r i p t i o n   a s   L i s t D t l D e s c  
 	 	 	 	 , S O D . Q t y S h i p p e d    
 	 	 	 	 , S O D . N e t U n i t P r i c e    
 	 	 	 	 , S O D . U n i t C o s t    
 	 	 	 	 , I B . P r i c e C o s t  
 	 	 	 	 , I B . C u r r e n t R e p l a c e m e n t C o s t    
 	 	 	 	 , I B . R e p l a c e m e n t C o s t    
 	 	 	 	 , S O H . I n v o i c e N o  
 	 	 	 	 , i s n u l l ( S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e , 0 )   a s   S a l e s  
 	 	 	 	 , S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d * S O D . U n i t C o s t   a s   A v g G M D o l  
 	 	 	 	 , C a s e   	 w h e n   i s n u l l ( I B . R e p l a c e m e n t C o s t , 0 )   =   0     t h e n   S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d * S O D . U n i t C o s t  
 	 	 	 	 	 	 E l s e   S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d * I B . R e p l a c e m e n t C o s t    
 	 	 	 	 E n d   a s   R p l G M D o l  
 	 	 	 	 , C a s e   	 w h e n   i s n u l l ( I B . P r i c e C o s t , 0 )   =   0     t h e n   S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d * S O D . U n i t C o s t  
 	 	 	 	 	 	 E l s e   S O D . Q t y S h i p p e d * S O D . N e t U n i t P r i c e   -   S O D . Q t y S h i p p e d * I B . P r i c e C o s t    
 	 	 	 	 E n d   a s   P r i c e G M D o l  
 	 	 	 	 , P r i c e . D i s c P c t   a s   E x i s t i n g C u s t P r i c e P c t  
 	 	 	 F R O M 	 I t e m B r a n c h   I B   ( N o L o c k )  
 	 	 	 I N N E R   J O I N   S O H e a d e r H i s t   S O H     ( N o L o c k )  
 	 	 	 I N N E R   J O I N   S O D e t a i l H i s t   S O D   ( N o L o c k )   O N    
 	 	 	 	 S O H . p S O H e a d e r H i s t I D   =   S O D . f S O H e a d e r H i s t I D    
 	 	 	 I N N E R   J O I N   I t e m M a s t e r   I M   ( N o L o c k )   O N    
 	 	 	 	 S O D . I t e m N o   =   I M . I t e m N o     O N    
 	 	 	 	 I B . f I t e m M a s t e r I D   =   I M . p I t e m M a s t e r I D    
 	 	 	 	 A N D   I B . L o c a t i o n   =   S O D . I M L o c    
 	 	 	 L e f t   O u t e r   J o i n   C a t e g o r y B u y G r o u p s   C A S   ( N o L o c k )   O N  
 	 	 	 	 C A S . C a t e g o r y   =   l e f t ( S O D . I t e m N o , 5 )  
 	 	 	 I N N E R   J O I N   F i s c a l C a l e n d a r   F C   ( N o L o c k )   O n  
 	 	 	 	 S O H . A R P o s t D t   =   F C . C u r r e n t D t  
 	 	 	 I N N E R   J O I N   C u s t o m e r M a s t e r   C M   ( N o l o c k )   O N  
 	 	 	 	 C M . C u s t N o   =   S O H . S e l l T o C u s t N o  
 	 	 	 L e f t   O u t e r   J o i n   C o m p e t i t o r P r i c e   C P   ( N o l o c k )   O N  
 	 	 	 	 C P . P F C I t e m   =   S O D . I t e m N o  
 	 	 	 L e f t   O u t e r   J o i n   C u s t o m e r P r i c e   P r i c e   ( N o l o c k )   O N  
 	 	 	 	 P r i c e . I t e m N o   =   C A S . G r o u p N o  
 	 	 	 	 a n d   P r i c e . C u s t N o   =   S O H . S e l l T o C u s t N o  
 	 	 	 - - U s e   l a s t   3   c l o s e d   m o n t h s   o f   S a l e s   I n v o i c e   d a t a ,   s k i p p i n g   C o m p e t i t o r P r i c e   t a b l e   i t e m s ,   B u l k   O n l y  
 	 	 	 W H E R E 	 s u b s t r i n g ( S O D . I t e m N o , 1 2 , 1 )   i n   ( ' 0 ' , ' 1 ' , ' 5 ' )  
 	 	 	 	 A N D   ( F C . F i s c a l C a l Y e a r * 1 0 0 + F i s c a l C a l M o n t h   B e t w e e n   ( d a t e p a r t ( y y y y , d a t e a d d ( m , - 3 , g e t d a t e ( ) ) ) * 1 0 0 ) + d a t e p a r t ( m , d a t e a d d ( m , - 3 , g e t d a t e ( ) ) )  
 	 	 	 	 A N D   ( d a t e p a r t ( y y y y , d a t e a d d ( m , - 1 , g e t d a t e ( ) ) ) * 1 0 0 ) + d a t e p a r t ( m , d a t e a d d ( m , - 1 , g e t d a t e ( ) ) ) )  
 	 	 	 	 A n d   C a s e   w h e n   C P . P F C I t e m   i s   n u l l   t h e n   ' '   e l s e   ' S k i p '   e n d   < > ' S K I P '  
 	 	 	 	 A N D   S O H . S e l l T o C u s t N o = @ C u s t N o  
 	 	 	 )   t m p  
 	 	 G r o u p   b y   C u s t N o ,   C u s t N a m e ,   B r a n c h ,   L i s t V a l u e , L i s t D t l D e s c  
 	 	 )   t m p 2  
 	 O r d e r   b y   t m p 2 . C u s t N o ,   t m p 2 . G r o u p S a l e s   d e s c ;  
  
 	 S E L E C T 	 C u s t N o   a s   C u s t o m e r N o  
 	 	 	 , C u s t N a m e   a s   C u s t o m e r N a m e  
 	 	 	 , S h i p L o c a t i o n   a s   B r a n c h  
 	 	 	 , C r e d i t I n d  
 	 	 	 , C o n t r a c t S c h d 1  
 	 	 	 , C o n t r a c t S c h d 2  
 	 	 	 , C o n t r a c t S c h d 3  
 	 	 	 , C o n t r a c t S c h e d u l e 4  
 	 	 	 , C o n t r a c t S c h e d u l e 5  
 	 	 	 , C o n t r a c t S c h e d u l e 6  
 	 	 	 , C o n t r a c t S c h e d u l e 7  
 	 	 	 , T a r g e t G r o s s M a r g i n P c t  
 	 	 	 , W e b D i s c o u n t P c t  
 	 	 	 , W e b D i s c o u n t I n d  
 	 	 	 , ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D = f L i s t M a s t e r I D   W H E R E   L i s t N a m e = ' C u s t D e f P r i c e S c h d ' )   L D  
 	 	 	 	   O N   L D . L i s t V a l u e = C u s t o m e r D e f a u l t P r i c e   W H E R E   C u s t N o = @ C u s t N o )   a s   C u s t o m e r D e f a u l t P r i c e  
 	 	 	 , ( S E L E C T   L D . L i s t D t l D e s c   F R O M   C u s t o m e r M a s t e r   ( N o L o c k )   I N N E R   J O I N  
 	 	 	 	 ( S E L E C T   L i s t V a l u e ,   L i s t D t l D e s c   F R O M   L i s t M a s t e r   ( N o L o c k )   I N N E R   J O I N   L i s t D e t a i l   ( N o L o c k )   O N   p L i s t M a s t e r I D = f L i s t M a s t e r I D   W H E R E   L i s t N a m e = ' C u s t P r i c e I n d ' )   L D  
 	 	 	 	   O N   L D . L i s t V a l u e = C u s t o m e r P r i c e I n d   W H E R E   C u s t N o = @ C u s t N o )   a s   C u s t o m e r P r i c e I n d  
 	 F R O M 	 C u s t o m e r M a s t e r   C M   ( N o l o c k )    
 	 W H E R E 	 C M . C u s t N o = @ C u s t N o ; 	  
  
 	 e n d ;  
  
 E n d 