i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ t W O 7 7 8 _ S O E x p e n s e H i s t ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s U s e r T a b l e ' )   =   1 )  
 d r o p   t a b l e   [ d b o ] . [ t W O 7 7 8 _ S O E x p e n s e H i s t ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ t W O 7 7 8 _ S O E x p e n s e H i s t ]   (  
 	 [ p S O E x p e n s e H i s t I D ]   [ b i g i n t ]   I D E N T I T Y   ( 1 ,   1 )   N O T   N U L L   ,  
 	 [ f S O H e a d e r H i s t I D ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ L i n e N u m b e r ]   [ i n t ]   N U L L   ,  
 	 [ E x p e n s e N o ]   [ i n t ]   N U L L   ,  
 	 [ E x p e n s e C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A m o u n t ]   [ f l o a t ]   N U L L   ,  
 	 [ C o s t ]   [ f l o a t ]   N U L L   ,  
 	 [ E x p e n s e I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T a x S t a t u s ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e l i v e r y C h a r g e ]   [ f l o a t ]   N U L L   ,  
 	 [ H a n d l i n g C h a r g e ]   [ f l o a t ]   N U L L   ,  
 	 [ P a c k a g i n g C h a r g e ]   [ f l o a t ]   N U L L   ,  
 	 [ M i s c C h a r g e ]   [ f l o a t ]   N U L L   ,  
 	 [ P h o n e C h a r g e ]   [ f l o a t ]   N U L L   ,  
 	 [ D o c u m e n t L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e l e t e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ E n t r y I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ E n t r y D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C h a n g e I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C h a n g e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S t a t u s C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ E x p e n s e D e s c ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L    
 )   O N   [ P R I M A R Y ]  
 G O  
  
 