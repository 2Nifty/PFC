 
 / *  
 	 	 F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . B I N L O C A T    
 	 	 F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C R F D B ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b e a c o n . d b o . B I N L O C A T    
  
 * /  
 C R E A T E   P R O C E D U R E   [ d b o ] . [ p W H S R c v R p r t D a t a ]  
 	 @ B r a n c h   V A R C H A R ( 1 0 ) ,  
 	 @ C o n t a i n e r   V A R C H A R ( 3 0 ) ,  
 	 @ L P N   V A R C H A R ( 3 0 )  
 A S  
 B E G I N  
 / *  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 A u t h o r : 	 	 T o m   S l a t e r  
 C r e a t e   d a t e :   1 0 / 1 3 / 2 0 0 9  
 D e s c r i p t i o n :   R u n s   i n   E R P   s y s t e m   t o   r e t u r n   a   d a t a   f o r   L P N   r e c e i v i n g   r e p o r t  
 I f   w e   g e t   o n l y   a   c o n t a i n e r   n u m b e r ,   E R P   c o n t r o l   t h e   d a t a  
 I f   w e   g e t   o n l y   a n   L P N   n u m b e r ,   R B   c o n t r o l s   t h e   d a t a  
 I f   w e   g e t   b o t h ,   w e   i n n e r   j o i n   b o t h   R B   a n d   E R P  
  
  
 L O A D   I N T O   E R P  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
  
 e x e c   p W H S R c v R p r t D a t a   ' 0 5 ' , ' ' , ' 0 5 P O C U 0 5 6 4 0 1 8 '  
 * /  
  
 - -   w e   o n l y   h a v e   a   c o n t a i n e r   n u m b e r   s o   E R P   c o n t r o l s   t h e   d a t a  
 i f   @ L P N = ' '   a n d   @ C o n t a i n e r < > ' '  
 	 b e g i n  
 	 s e l e c t   d i s t i n c t  
 	 L P N D a t a . L P N N o   a s   L P N  
 	 , L P N D a t a . L o c a t i o n   a s   L o c a t i o n  
 	 , L P N D a t a . I t e m N o   a s   I t e m N o  
 	 , L P N D a t a . R e c e i p t B i n   a s   B i n  
 	 , I t e m M a s t e r . I t e m D e s c  
 	 , c o a l e s c e ( L P N D a t a . E n t r y D t ,   R B D a t a . D a t e C r e a t e )   a s   P o s t D a t e  
 	 , c o a l e s c e ( L P N D a t a . L P N Q t y , R B D a t a . Q U A N T I T Y )   a s   O r i g Q t y  
 	 , c o a l e s c e ( L P N D a t a . R e c e i v e d Q t y , 0 )   a s   R c v d Q t y  
 	 , c o a l e s c e ( L P N D a t a . I n t r a n s i t Q t y , 0 )   a s   S h i p p e d Q t y  
 	 , c o a l e s c e ( R B D a t a . Q U A N T I T Y , 0 )   a s   O p e n Q t y  
 	 , i s n u l l ( L P N D a t a . B O L N o , ' N o   L P N   D a t a ' )   a s   B O L N o  
 	 , i s n u l l ( L P N D a t a . C o n t a i n e r N o , ' ' )   a s   C o n t a i n e r N o  
 	 , i s n u l l ( L P N D a t a . D o c u m e n t N o , ' ' )   a s   D o c  
 	 , i s n u l l ( L P N D a t a . O r i g i n a l D o c N o , ' ' )   a s   O r i g D o c  
 	 , i s n u l l ( L P N D a t a . I n T r a n s i t L o c a t i o n , ' ' )   a s   I n T r a n s i t  
 	 , i s n u l l ( L P N D a t a . V e n d o r C u s t N o , ' ' )   a s   V e n d o r  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D , ' ' )   a s   S o u r c e D o c 1  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D 2 , ' ' )   a s   S o u r c e D o c 2  
 	 , c o a l e s c e ( L P N D a t a . T r a n s a c t i o n U M , I t e m M a s t e r . S e l l S t k U M ,   ' ' )   a s   U O M  
 	 , T o L o c . L o c N a m e   a s   T o L o c N a m e  
 	 , T o L o c . L o c A d r e s s 1   a s   T o L o c A d r e s s 1  
 	 , T o L o c . L o c A d r e s s 2   a s   T o L o c A d r e s s 2  
 	 , T o L o c . L o c C i t y   +   ' ,   '   +   T o L o c . L o c S t a t e   +   ' .     '   +   T o L o c . L o c P o s t C o d e   a s   T o L o c C i t y S t Z i p  
 	 , c o a l e s c e ( F r o m L o c a t i o n , s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 ) )   a s   F r o m L o c  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c N a m e ,   F r o m L o c R c p t . L o c N a m e ,   ' L o c M a s t e r   M i s s i n g   f o r   ' +   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 ) )   a s   F r o m L o c N a m e  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c A d r e s s 1 , F r o m L o c R c p t . L o c A d r e s s 1 , ' ' )   a s   F r o m L o c A d r e s s 1  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c A d r e s s 2 , F r o m L o c R c p t . L o c A d r e s s 2 , ' ' )   a s   F r o m L o c A d r e s s 2  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c C i t y , F r o m L o c R c p t . L o c C i t y , ' ' )   +   ' ,   '   +   c o a l e s c e ( F r o m L o c T r a n s i t . L o c S t a t e , F r o m L o c R c p t . L o c S t a t e , ' ' )   +   ' .     '   +   c o a l e s c e ( F r o m L o c T r a n s i t . L o c P o s t C o d e , F r o m L o c R c p t . L o c P o s t C o d e , ' ' )   a s   F r o m L o c C i t y S t Z i p  
 	 f r o m   L P N A u d i t C o n t r o l   L P N D a t a     w i t h   ( N O L O C K )  
 	 i n n e r   j o i n   I t e m M a s t e r   w i t h   ( N O L O C K )  
 	 o n   I t e m M a s t e r . I t e m N o   =   L P N D a t a . I t e m N o  
 	 l e f t   o u t e r   j o i n    
 	 (  
 	 	 S E L E C T   d i s t i n c t  
 	 	 L O C A T I O N ,  
 	 	 L I C E N S E _ P L A T E ,    
 	 	 B I N L A B E L ,  
 	 	 P R O D U C T ,  
 	 	 s u m ( Q U A N T I T Y )   a s   Q U A N T I T Y ,  
 	 	 m i n ( D A T E C R E A T E )   a s   D a t e C r e a t e  
 	 	 F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . B I N L O C A T    
 	 	 W H E R E   L O C A T I O N   =   @ B r a n c h  
 	 	 	 a n d   Q U A N T I T Y   < >   0  
 	 	 G R O U P   B Y   L O C A T I O N ,   B I N L A B E L ,   L I C E N S E _ P L A T E ,   P R O D U C T  
 	 )   R B D a t a  
 	 o n   L P N D a t a . L P N N o   =   R B D a t a . L I C E N S E _ P L A T E  
 	 	 a n d   L P N D a t a . L o c a t i o n   =   R B D a t a . L O C A T I O N  
 	 	 a n d   L P N D a t a . R e c e i p t B i n   =   R B D a t a . B I N L A B E L  
 	 	 a n d   L P N D a t a . I t e m N o   =   R B D a t a . P R O D U C T  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   T o L o c   w i t h   ( N O L O C K )  
 	 o n   L P N D a t a . L o c a t i o n   =   T o L o c . L o c I D  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   F r o m L o c T r a n s i t   w i t h   ( N O L O C K )  
 	 o n   L P N D a t a . F r o m L o c a t i o n   =   F r o m L o c T r a n s i t . L o c I D  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   F r o m L o c R c p t   w i t h   ( N O L O C K )  
 	 o n   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 )   =   F r o m L o c R c p t . L o c I D  
 	 w h e r e   L P N D a t a . C o n t a i n e r N o   =   @ C o n t a i n e r  
 	 - - a n d   L P N D a t a . F r o m L o c a t i o n   =   @ B r a n c h  
 	 e n d ;  
  
 - -   w e   o n l y   h a v e   a n   L P N   n u m b e r   s o   R B   c o n t r o l s   t h e   d a t a  
 i f   @ L P N < > ' '   a n d   @ C o n t a i n e r = ' '  
 	 b e g i n  
 	 s e l e c t   d i s t i n c t  
 	 R B D a t a . L I C E N S E _ P L A T E   a s   L P N  
 	 , R B D a t a . L O C A T I O N   a s   L o c a t i o n  
 	 , R B D a t a . P R O D U C T   a s   I t e m N o  
 	 , R B D a t a . B I N L A B E L   a s   B i n  
 	 , I t e m M a s t e r . I t e m D e s c  
 	 , c o a l e s c e ( L P N D a t a . E n t r y D t ,   R B D a t a . D a t e C r e a t e )   a s   P o s t D a t e  
 	 , i s n u l l ( L P N D a t a . L P N Q t y , R B D a t a . Q U A N T I T Y )   a s   O r i g Q t y  
 	 , i s n u l l ( L P N D a t a . R e c e i v e d Q t y , 0 )   a s   R c v d Q t y  
 	 , i s n u l l ( L P N D a t a . I n t r a n s i t Q t y , 0 )   a s   S h i p p e d Q t y  
 	 , R B D a t a . Q U A N T I T Y   a s   O p e n Q t y  
 	 , i s n u l l ( L P N D a t a . B O L N o , ' N o   L P N   D a t a ' )   a s   B O L N o  
 	 , i s n u l l ( L P N D a t a . C o n t a i n e r N o , ' ' )   a s   C o n t a i n e r N o  
 	 , i s n u l l ( L P N D a t a . D o c u m e n t N o , @ L P N )   a s   D o c  
 	 , i s n u l l ( L P N D a t a . O r i g i n a l D o c N o , ' ' )   a s   O r i g D o c  
 	 , i s n u l l ( L P N D a t a . I n T r a n s i t L o c a t i o n , ' ' )   a s   I n T r a n s i t  
 	 , i s n u l l ( L P N D a t a . V e n d o r C u s t N o , ' ' )   a s   V e n d o r  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D , ' ' )   a s   S o u r c e D o c 1  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D 2 , ' ' )   a s   S o u r c e D o c 2  
 	 , c o a l e s c e ( L P N D a t a . T r a n s a c t i o n U M , I t e m M a s t e r . S e l l S t k U M ,   ' ' )   a s   U O M  
 	 , T o L o c . L o c N a m e   a s   T o L o c N a m e  
 	 , T o L o c . L o c A d r e s s 1   a s   T o L o c A d r e s s 1  
 	 , T o L o c . L o c A d r e s s 2   a s   T o L o c A d r e s s 2  
 	 , T o L o c . L o c C i t y   +   ' ,   '   +   T o L o c . L o c S t a t e   +   ' .     '   +   T o L o c . L o c P o s t C o d e   a s   T o L o c C i t y S t Z i p  
 	 , s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 )   a s   F r o m L o c  
 	 , i s n u l l ( F r o m L o c . L o c N a m e ,   ' L o c M a s t e r   M i s s i n g   f o r   ' +   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 ) )   a s   F r o m L o c N a m e  
 	 , i s n u l l ( F r o m L o c . L o c A d r e s s 1 , ' ' )   a s   F r o m L o c A d r e s s 1  
 	 , i s n u l l ( F r o m L o c . L o c A d r e s s 2 , ' ' )   a s   F r o m L o c A d r e s s 2  
 	 , i s n u l l ( F r o m L o c . L o c C i t y , ' ' )   +   ' ,   '   +   i s n u l l ( F r o m L o c . L o c S t a t e , ' ' )   +   ' .     '   +   i s n u l l ( F r o m L o c . L o c P o s t C o d e , ' ' )   a s   F r o m L o c C i t y S t Z i p  
 	 f r o m    
 	 (  
 	 	 S E L E C T   d i s t i n c t  
 	 	 L O C A T I O N ,  
 	 	 L I C E N S E _ P L A T E ,    
 	 	 B I N L A B E L ,  
 	 	 P R O D U C T ,  
 	 	 s u m ( Q U A N T I T Y )   a s   Q U A N T I T Y ,  
 	 	 m i n ( D A T E C R E A T E )   a s   D a t e C r e a t e  
 	 	 F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . B I N L O C A T    
 	 	 W H E R E   L I C E N S E _ P L A T E   =   @ L P N  
 	 	 	 a n d   L O C A T I O N   =   @ B r a n c h  
 	 	 	 a n d   Q U A N T I T Y   < >   0  
 	 	 G R O U P   B Y   L O C A T I O N ,   B I N L A B E L ,   L I C E N S E _ P L A T E ,   P R O D U C T  
 	 )   R B D a t a  
 	 i n n e r   j o i n   I t e m M a s t e r   w i t h   ( N O L O C K )  
 	 o n   I t e m M a s t e r . I t e m N o   =   R B D a t a . P R O D U C T  
 	 l e f t   o u t e r   j o i n   L P N A u d i t C o n t r o l   L P N D a t a   w i t h   ( N O L O C K )  
 	 o n   L P N D a t a . L P N N o   =   R B D a t a . L I C E N S E _ P L A T E  
 	 	 a n d   L P N D a t a . L o c a t i o n   =   R B D a t a . L O C A T I O N  
 	 	 a n d   L P N D a t a . R e c e i p t B i n   =   R B D a t a . B I N L A B E L  
 	 	 a n d   L P N D a t a . I t e m N o   =   R B D a t a . P R O D U C T  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   T o L o c   w i t h   ( N O L O C K )  
 	 o n   R B D a t a . L O C A T I O N   =   T o L o c . L o c I D  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   F r o m L o c   w i t h   ( N O L O C K )  
 	 o n   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 )   =   F r o m L o c . L o c I D  
 	 e n d ;  
  
 - -   w e   h a v e   b o t h   s o   w e   i n n e r   j o i n   b o t h   R B   a n d   E R P  
 i f   @ L P N < > ' '   a n d   @ C o n t a i n e r < > ' '  
 	 b e g i n  
 	 s e l e c t   d i s t i n c t  
 	 R B D a t a . L I C E N S E _ P L A T E   a s   L P N  
 	 , R B D a t a . L O C A T I O N   a s   L o c a t i o n  
 	 , R B D a t a . P R O D U C T   a s   I t e m N o  
 	 , R B D a t a . B I N L A B E L   a s   B i n  
 	 , I t e m M a s t e r . I t e m D e s c  
 	 , c o a l e s c e ( L P N D a t a . E n t r y D t ,   R B D a t a . D a t e C r e a t e )   a s   P o s t D a t e  
 	 , i s n u l l ( L P N D a t a . L P N Q t y , R B D a t a . Q U A N T I T Y )   a s   O r i g Q t y  
 	 , i s n u l l ( L P N D a t a . R e c e i v e d Q t y , 0 )   a s   R c v d Q t y  
 	 , c o a l e s c e ( L P N D a t a . I n t r a n s i t Q t y , 0 )   a s   S h i p p e d Q t y  
 	 , R B D a t a . Q U A N T I T Y   a s   O p e n Q t y  
 	 , i s n u l l ( L P N D a t a . B O L N o , ' N o   L P N   D a t a ' )   a s   B O L N o  
 	 , i s n u l l ( L P N D a t a . C o n t a i n e r N o , ' ' )   a s   C o n t a i n e r N o  
 	 , i s n u l l ( L P N D a t a . D o c u m e n t N o , ' ' )   a s   D o c  
 	 , i s n u l l ( L P N D a t a . O r i g i n a l D o c N o , @ L P N )   a s   O r i g D o c  
 	 , i s n u l l ( L P N D a t a . I n T r a n s i t L o c a t i o n , ' ' )   a s   I n T r a n s i t  
 	 , i s n u l l ( L P N D a t a . V e n d o r C u s t N o , ' ' )   a s   V e n d o r  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D , ' ' )   a s   S o u r c e D o c 1  
 	 , i s n u l l ( L P N D a t a . S o u r c e D o c u m e n t I D 2 , ' ' )   a s   S o u r c e D o c 2  
 	 , c o a l e s c e ( L P N D a t a . T r a n s a c t i o n U M , I t e m M a s t e r . S e l l S t k U M ,   ' ' )   a s   U O M  
 	 , T o L o c . L o c N a m e   a s   T o L o c N a m e  
 	 , T o L o c . L o c A d r e s s 1   a s   T o L o c A d r e s s 1  
 	 , T o L o c . L o c A d r e s s 2   a s   T o L o c A d r e s s 2  
 	 , T o L o c . L o c C i t y   +   ' ,   '   +   T o L o c . L o c S t a t e   +   ' .     '   +   T o L o c . L o c P o s t C o d e   a s   T o L o c C i t y S t Z i p  
 	 , c o a l e s c e ( F r o m L o c a t i o n , s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 ) )   a s   F r o m L o c  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c N a m e ,   F r o m L o c R c p t . L o c N a m e ,   ' L o c M a s t e r   M i s s i n g   f o r   ' +   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 ) )   a s   F r o m L o c N a m e  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c A d r e s s 1 , F r o m L o c R c p t . L o c A d r e s s 1 , ' ' )   a s   F r o m L o c A d r e s s 1  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c A d r e s s 2 , F r o m L o c R c p t . L o c A d r e s s 2 , ' ' )   a s   F r o m L o c A d r e s s 2  
 	 , c o a l e s c e ( F r o m L o c T r a n s i t . L o c C i t y , F r o m L o c R c p t . L o c C i t y , ' ' )   +   ' ,   '   +   c o a l e s c e ( F r o m L o c T r a n s i t . L o c S t a t e , F r o m L o c R c p t . L o c S t a t e , ' ' )   +   ' .     '   +   c o a l e s c e ( F r o m L o c T r a n s i t . L o c P o s t C o d e , F r o m L o c R c p t . L o c P o s t C o d e , ' ' )   a s   F r o m L o c C i t y S t Z i p  
 	 f r o m    
 	 (  
 	 	 S E L E C T   d i s t i n c t  
 	 	 L O C A T I O N ,  
 	 	 L I C E N S E _ P L A T E ,    
 	 	 B I N L A B E L ,  
 	 	 P R O D U C T ,  
 	 	 s u m ( Q U A N T I T Y )   a s   Q U A N T I T Y ,  
 	 	 m i n ( D A T E C R E A T E )   a s   D a t e C r e a t e  
 	 	 F R O M   O p e n D a t a S o u r c e ( ' S Q L O L E D B ' , ' D a t a   S o u r c e = P F C D B 0 5 ; U s e r   I D = p f c n o r m a l ; P a s s w o r d = p f c n o r m a l ' ) . r b t e s t . d b o . B I N L O C A T    
 	 	 W H E R E   L I C E N S E _ P L A T E   =   @ L P N  
 	 	 	 a n d   L O C A T I O N   =   @ B r a n c h  
 	 	 	 a n d   Q U A N T I T Y   < >   0  
 	 	 G R O U P   B Y   L O C A T I O N ,   B I N L A B E L ,   L I C E N S E _ P L A T E ,   P R O D U C T  
 	 )   R B D a t a  
 	 i n n e r   j o i n   I t e m M a s t e r   w i t h   ( N O L O C K )  
 	 o n   I t e m M a s t e r . I t e m N o   =   R B D a t a . P R O D U C T  
 	 i n n e r   j o i n   L P N A u d i t C o n t r o l   L P N D a t a   w i t h   ( N O L O C K )  
 	 o n   L P N D a t a . L P N N o   =   R B D a t a . L I C E N S E _ P L A T E  
 	 	 a n d   L P N D a t a . L o c a t i o n   =   R B D a t a . L O C A T I O N  
 	 	 a n d   L P N D a t a . R e c e i p t B i n   =   R B D a t a . B I N L A B E L  
 	 	 a n d   L P N D a t a . I t e m N o   =   R B D a t a . P R O D U C T  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   T o L o c   w i t h   ( N O L O C K )  
 	 o n   R B D a t a . L O C A T I O N   =   T o L o c . L o c I D  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   F r o m L o c T r a n s i t   w i t h   ( N O L O C K )  
 	 o n   L P N D a t a . F r o m L o c a t i o n   =   F r o m L o c T r a n s i t . L o c I D  
 	 l e f t   o u t e r   j o i n   L o c M a s t e r   F r o m L o c R c p t   w i t h   ( N O L O C K )  
 	 o n   s u b s t r i n g ( R B D a t a . B I N L A B E L , 7 , 8 )   =   F r o m L o c R c p t . L o c I D  
 	 w h e r e   L P N D a t a . C o n t a i n e r N o   =   @ C o n t a i n e r  
 	 - - a n d   L P N D a t a . F r o m L o c a t i o n   =   @ B r a n c h  
 	 e n d ;  
  
  
 E N D 