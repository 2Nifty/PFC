 
 i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ t W O 7 7 8 _ S O H e a d e r H i s t ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s U s e r T a b l e ' )   =   1 )  
 d r o p   t a b l e   [ d b o ] . [ t W O 7 7 8 _ S O H e a d e r H i s t ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ t W O 7 7 8 _ S O H e a d e r H i s t ]   (  
 	 [ p S O H e a d e r H i s t I D ]   [ i n t ]   I D E N T I T Y   ( 1 ,   1 )   N O T   N U L L   ,  
 	 [ O r d e r N o ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ O r d e r R e l N o ]   [ n u m e r i c ] ( 4 ,   0 )   N U L L   ,  
 	 [ O r d e r T y p e ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r T y p e D s c ]   [ v a r c h a r ]   ( 6 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I n v o i c e N o ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P r i c e C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D i s c o u n t C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T o t a l O r d e r ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ T o t a l C o s t ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ T o t a l C o s t 2 ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ C o m m D o l ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ C o m m P c t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ D i s c P c t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ C o m S p l i t 1 ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ C o m S p l i t 2 ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ C o m S p l i t 3 ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ S l s R e p I d 1 ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ S l s R e p I d 2 ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ S l s R e p I d 3 ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ N e t S a l e s ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ T a x S u m ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ N o n T a x A m t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ T a x E x p A m t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ N o n T a x E x p A m t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ T a x A m t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ C r e d i t C d A m t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ S h i p W g h t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ B O L W g h t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ B i l l T o C u s t N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o C u s t N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o A d d r e s s 1 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o A d d r e s s 2 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o A d d r e s s 3 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o C i t y ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o S t a t e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o Z i p ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o P r o v i n c e ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o C o u n t r y ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o C o n t a c t N a m e ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i l l T o C o n t a c t P h o n e N o ]   [ v a r c h a r ]   ( 2 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C u s t N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C u s t N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o A d d r e s s 1 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o A d d r e s s 2 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o A d d r e s s 3 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C i t y ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o S t a t e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o Z i p ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o P r o v i n c e ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C o u n t r y ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C o n t a c t N a m e ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l T o C o n t a c t P h o n e N o ]   [ v a r c h a r ]   ( 2 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e l e t e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C o m p l e t e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ V e r i f y D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ P r i n t D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ I n v o i c e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ A R P o s t D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S c h S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C o n f i r m S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ P i c k D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ P i c k C o m p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ A l l o c D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ H o l d D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r d e r D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r d e r P r o m D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r d e r L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r L o c N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p L o c N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s a g e L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s a g e L o c N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r S t a t u s ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ H o l d R e a s o n ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ H o l d R e a s o n N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P r i c e R v w F l a g ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e a s o n C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e a s o n C d N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B O F l a g ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r M e t h C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r M e t h N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r T e r m s C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r T e r m s N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r P r i o r i t y C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r P r i N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r E x p d C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r E x p d C d N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T a x S t a t ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C r e d i t S t a t ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S a l e s R e p N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S a l e s R e p N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t S v c R e p N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t S v c R e p N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o p i e s t o P r i n t ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ O r d e r C a r r i e r ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r C a r N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C r e d i t A u t h N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B O L N O ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ N o C a r t o n s ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ S h i p I n s t r C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p I n s t r C d N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S a l e s T a x R t ]   [ n u m e r i c ] ( 7 ,   4 )   N U L L   ,  
 	 [ P O R e f N o ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ R e s a l e N o ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ V e r i f y T y p e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o n f i r m D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ R l s W h s e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S t a g e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S t a g e B i n ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ C o n s o l i d a t e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C o m I n v P r t D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S h i p p e d D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C o m m M e d i a ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S u b T y p e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ H e a d e r S t a t u s ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r i g S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r i g S h i p D t 1 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r i g S h i p D t 2 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r i g S h i p D t 3 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O n e T i m e S T N o ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ L i n e s C h a n g e d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e I t e m O d o m ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ N o L a t e r D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C u s t o T y p e ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t T y p e N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S c a n Q t y ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ L i s t C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A c k P r i n t e d D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C u s t S h i p L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T h r u L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e o r d e r U s e L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s e r 2 ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s e r 3 ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s e r 4 ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ U s e r 5 ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p p i n g M a r k 1 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p p i n g M a r k 2 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p p i n g M a r k 3 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p p i n g M a r k 4 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r R e p r i n t s ]   [ i n t ]   N U L L   ,  
 	 [ D r o p V e n d o r I D ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ D r o p V e n d o r N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e c o m m e n d C a r C d ]   [ c h a r ]   ( 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e c o m m e n d C a r N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S u r C h a r g e I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S u m m a r y B i l l I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e f e r e n c e N o ]   [ v a r c h a r ]   ( 1 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C a s h I t e m O d m ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ C u s t T a x R a t e C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S t a t e T a x C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o u n t y T a x C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C i t y T a x C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T a x D i s t r i c t ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e m i t C d ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ D i s c N e t 1 P C t ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ D i s c N e t 2 P C t ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ D i s c N e t 3 P C t ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ A S N F m t ]   [ v a r c h a r ]   ( 1 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ J o b N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ J o b N o ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ J o b L o c a t i o n ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e s t i n a t i o n ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ J o b B u i l d i n g ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A S A P i n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T o C d ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T o N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T o A d d r e s s 1 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T o A d d r e s s 2 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T o A d d r e s s 3 ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C i t y ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S t a t e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ Z i p ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P h o n e N o ]   [ v a r c h a r ]   ( 2 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ F a x N o ]   [ v a r c h a r ]   ( 2 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o n t a c t N a m e ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o n t a c t P h o n e N o ]   [ v a r c h a r ]   ( 2 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P r o v i n c e ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o u n t r y ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o u n t r y C d ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ E n t r y D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ E n t r y I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C h a n g e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C h a n g e I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S t a t u s C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t P O N o ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e f S O N o ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r F r e i g h t C d ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r F r e i g h t N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P e n d i n g D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S h i p M e t h o d N a m e ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e m a r k s ]   [ v a r c h a r ]   ( 8 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T a x R a t e C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B r a n c h R e q D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r d e r C o n t a c t N a m e ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D i s c o u n t A m t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ f S O H e a d e r I D ]   [ i n t ]   N U L L   ,  
 	 [ C u s t R e q D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S h i p T o C o n t a c t I D ]   [ i n t ]   N U L L   ,  
 	 [ S e l l T o C o n t a c t I D ]   [ i n t ]   N U L L   ,  
 	 [ M a k e O r d e r D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C u s t C a r r i e r A c c t ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A l l o w B O I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o n s o l i d a t e O r d e r s I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p C o m p l e t e I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e v i e w I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e v i e w D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ A l l o c R e l D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ I n v o i c e S e n d M e t h o d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I n v o i c e S e n d D e s t ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I n v o i c e S e n d D a t e 1 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ I n v o i c e S e n d D a t e 2 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ I n v o i c e S e n d D a t e 3 ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ I n v o i c e S e n t ]   [ i n t ]   N U L L   ,  
 	 [ I n v o i c e F i l e d ]   [ i n t ]   N U L L   ,  
 	 [ R e s e n d I n v o i c e ]   [ i n t ]   N U L L   ,  
 	 [ R e f i l e I n v o i c e ]   [ i n t ]   N U L L   ,  
 	 [ D i s c o u n t A m o u n t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ D i s c o u n t D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ A R D u e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ f C u s t o m e r A d d r e s s I D ]   [ i n t ]   N U L L   ,  
 	 [ D e l e t e R e a s o n C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e l e t e R e a s o n N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e l e t e U s e r I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p T r a c k i n g N o ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S h i p p i n g C o s t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ D o c u m e n t S o r t I n d ]   [ c h a r ]   ( 1 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C e r t R e q u i r e d I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r S o u r c e ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L    
 )   O N   [ P R I M A R Y ]  
 G O  
  
 