I F     E X I S T S   ( S E L E C T   *   F R O M   s y s . o b j e c t s   W H E R E   o b j e c t _ i d   =   O B J E C T _ I D ( N ' [ d b o ] . [ t W O 1 3 7 6 _ P o r t e o u s $ S a l e s   L i n e   C o m m e n t   L i n e ] ' )   A N D   t y p e   i n   ( N ' U ' ) )  
 D R O P   T A B L E   [ d b o ] . [ t W O 1 3 7 6 _ P o r t e o u s $ S a l e s   L i n e   C o m m e n t   L i n e ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ t W O 1 3 7 6 _ P o r t e o u s $ S a l e s   L i n e   C o m m e n t   L i n e ]   (  
 	 [ t i m e s t a m p ]   [ t i m e s t a m p ]   N O T   N U L L ,  
 	 [ D o c u m e n t   T y p e ]   [ i n t ]   N O T   N U L L ,  
 	 [ N o _ ]   [ v a r c h a r ]   ( 2 0 )   N O T   N U L L ,  
 	 [ D o c _   L i n e   N o _ ]   [ i n t ]   N O T   N U L L ,  
 	 [ L i n e   N o _ ]   [ i n t ]   N O T   N U L L ,  
 	 [ D a t e ]   [ d a t e t i m e ]   N O T   N U L L ,  
 	 [ C o d e ]   [ v a r c h a r ]   ( 1 0 )   N O T   N U L L ,  
 	 [ C o m m e n t ]   [ v a r c h a r ]   ( 5 0 )   N O T   N U L L ,  
 	 [ P r i n t   O n   Q u o t e ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   P i c k   T i c k e t ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   O r d e r   C o n f i r m a t i o n ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   S h i p m e n t ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   I n v o i c e ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   C r e d i t   M e m o ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   W o r k s h e e t ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ P r i n t   O n   B l a n k e t ]   [ t i n y i n t ]   N O T   N U L L ,  
 	 [ U s e r   I D ]   [ v a r c h a r ]   ( 2 0 )   N O T   N U L L ,  
 	 [ T i m e   S t a m p ]   [ d a t e t i m e ]   N O T   N U L L    
 )   O N   [ P R I M A R Y ]  
 G O  
  
 