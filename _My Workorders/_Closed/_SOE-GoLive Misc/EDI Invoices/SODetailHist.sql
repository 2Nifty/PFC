i f   e x i s t s   ( s e l e c t   *   f r o m   d b o . s y s o b j e c t s   w h e r e   i d   =   o b j e c t _ i d ( N ' [ d b o ] . [ t W O 7 7 8 _ S O D e t a i l H i s t ] ' )   a n d   O B J E C T P R O P E R T Y ( i d ,   N ' I s U s e r T a b l e ' )   =   1 )  
 d r o p   t a b l e   [ d b o ] . [ t W O 7 7 8 _ S O D e t a i l H i s t ]  
 G O  
  
 C R E A T E   T A B L E   [ d b o ] . [ t W O 7 7 8 _ S O D e t a i l H i s t ]   (  
 	 [ p S O D e t a i l H i s t I D ]   [ i n t ]   I D E N T I T Y   ( 1 ,   1 )   N O T   N U L L   ,  
 	 [ f S O H e a d e r H i s t I D ]   [ i n t ]   N U L L   ,  
 	 [ L i n e N u m b e r ]   [ i n t ]   N U L L   ,  
 	 [ L i n e S e q ]   [ i n t ]   N U L L   ,  
 	 [ L i n e T y p e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e P r i c e I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e R e a s o n ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e R e a s o n D s c ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e E x p d C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e E x p d C d D s c ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L i n e S t a t u s ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P O L i n e ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ T a x S t a t u s ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I t e m N o ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I t e m D s c ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B i n L o c ]   [ v a r c h a r ]   ( 1 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I M L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D i s c I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e l e a s e I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o s t I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e r v C h r g I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ X r e f C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ O r d e r L v l C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B O L C a t e g o r y C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ P r i c e C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e a l e r C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L I S C ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ L I S o u r c e ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ R e v L v l ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ Q t y S t a t ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ D e a l e r N o ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C o m P c t ]   [ n u m e r i c ] ( 5 ,   2 )   N U L L   ,  
 	 [ C o m D o l ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ N e t U n i t P r i c e ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ L i s t U n i t P r i c e ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ D i s c U n i t P r i c e ]   [ n u m e r i c ] ( 3 8 ,   2 0 )   N U L L   ,  
 	 [ D i s c P c t 1 ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ D i s c P c t 2 ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ D i s c P c t 3 ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ Q t y A v a i l L o c 1 ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ Q t y A v a i l 1 ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ Q t y A v a i l L o c 2 ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ Q t y A v a i l 2 ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ Q t y A v a i l L o c 3 ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ Q t y A v a i l 3 ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ O r i g O r d e r N o ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ O r i g O r d e r L i n e N o ]   [ n u m e r i c ] ( 9 ,   0 )   N U L L   ,  
 	 [ R q s t d S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ O r i g S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ A c t u a l S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ L i n e S c h D t C h a n g e ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ S u g g s t d S h i p D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ D e l e t e D t ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ Q t y O r d e r e d ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ Q t y S h i p p e d ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ Q t y B O ]   [ n u m e r i c ] ( 1 5 ,   2 )   N U L L   ,  
 	 [ S e l l S t k U M ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S e l l S t k F a c t o r ]   [ n u m e r i c ] ( 5 ,   0 )   N U L L   ,  
 	 [ U n i t C o s t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ U n i t C o s t 2 ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ U n i t C o s t 3 ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ R e p C o s t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ O E C o s t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ R e b a t e A m t ]   [ n u m e r i c ] ( 1 5 ,   5 )   N U L L   ,  
 	 [ S u g g s t d S h i p F r L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S u g g s t d S h i p F r N a m e ]   [ v a r c h a r ]   ( 4 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ N o R e s c h d ]   [ s m a l l i n t ]   N U L L   ,  
 	 [ R e m a r k ]   [ v a r c h a r ]   ( 8 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t I t e m N o ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C u s t I t e m D s c ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ B O M Q t y P e r ]   [ n u m e r i c ] ( 1 0 ,   0 )   N U L L   ,  
 	 [ B O M Q t y I s s u e d ]   [ n u m e r i c ] ( 1 0 ,   4 )   N U L L   ,  
 	 [ E n t r y D a t e ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ E n t r y I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C h a n g e D a t e ]   [ d a t e t i m e ]   N U L L   ,  
 	 [ C h a n g e I D ]   [ v a r c h a r ]   ( 5 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S t a t u s C d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ G r o s s W g h t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ N e t W g h t ]   [ n u m e r i c ] ( 1 5 ,   4 )   N U L L   ,  
 	 [ E x t e n d e d P r i c e ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ E x t e n d e d C o s t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ E x t e n d e d N e t W g h t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ E x t e n d e d G r o s s W g h t ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ S e l l S t k Q t y ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ A l t e r n a t e U M ]   [ c h a r ]   ( 4 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A l t e r n a t e U M Q t y ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ S h i p T h r u L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ f S O D e t a i l I D ]   [ i n t ]   N U L L   ,  
 	 [ Q t y S t a t u s ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ E x c l u d e d F r o m U s a g e F l a g ]   [ t i n y i n t ]   N U L L   ,  
 	 [ O r i g i n a l Q t y R e q u e s t e d ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ U s a g e L o c ]   [ v a r c h a r ]   ( 1 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ A l t e r n a t e P r i c e ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ S u p e r E q u i v Q t y ]   [ d e c i m a l ] ( 1 8 ,   6 )   N U L L   ,  
 	 [ S u p e r E q u i v U M ]   [ v a r c h a r ]   ( 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C a r r i e r C d ]   [ c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ I M L o c N a m e ]   [ v a r c h a r ]   ( 3 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ S t k U M ]   [ v a r c h a r ]   ( 5 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ F r e i g h t C d ]   [ v a r c h a r ]   ( 2 0 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L   ,  
 	 [ C e r t R e q u i r e d I n d ]   [ c h a r ]   ( 2 )   C O L L A T E   S Q L _ L a t i n 1 _ G e n e r a l _ C P 1 _ C I _ A S   N U L L    
 )   O N   [ P R I M A R Y ]  
 G O  
  
 