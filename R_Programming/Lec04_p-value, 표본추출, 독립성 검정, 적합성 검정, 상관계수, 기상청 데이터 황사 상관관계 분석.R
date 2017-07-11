#### Lecture 04. p-value, 표본추출, 독립성 검정, 적합성 검정, 상관계수, 기상청 데이터 황사 상관관계 분석 

## p-value란?
# p-value는, 귀무가설(null hypothesis, H0)이 맞다는 전제 하에, 
# 통계값(statistics)이 실제로 관측된 값 이상일 확률을 의미한다. 

## 난수생성/ 분포함수

options(digits = 3)
set.seed(100) # 포인트를 정하면 난수를 동일하게 지정
x1 = rnorm(100, mean = 0, sd = 3)

hist(x1)

plot(density(rnorm(1000000,0,10))) # rnom -- 정규분포 형태 (표본수, 평균, 표준편차)
mean(x1)
var(x1)

median(x1)

quantile(x1, 0.5) ## 50%의 위치

quantile(x1, c(0.25, 0.5, 0.75)) ## 각각의 수치에 해당하는 위치(상위 25%, 50%, 75%)

dpois(3,1)

q1 = quantile(1:10, c(1/4, 3/4))
str(q1)
q1[2] - q1[1] # [1]은 q1의 c(첫번째값) 

### 표본 추출

# 컴퓨터를 사용하여 기계적으로 데이터를 처리하는 경우라 할지라도 분석할 데이터 역시
# 기하급수적으로 늘어나기에 올바른 표본의 추출 방법은 더없이 중요하다.

## 단순 임의 추출

sample(1:10, 10)
sample(1:10, 10, replace = T)

ind1 = sample(nrow(iris), nrow(iris), replace = F)
# ind1 = sample(150개, 150번, 비복원 추출) -- 랜덤으로 다시 줄세우기

A1 = iris[ind1,]
A1
n1 = nrow(iris)

train = A1[1:(n1 * 0.7), ]      ## iris 데이터의 70%를 임의로 추출
test0 = A1[((n1*0.7)+1):n1, ]   ## 
test1 = A1[-(1:(n1*0.7)), ]     ## test0 과 test1이 같다.


ind2 = sample(n1, n1*0.7, replace = F)
train1 = iris[ind2, ]
test1 = iris[-ind2, ]

## true에 해당하는 값만 넘겨줌.

ind3 = sample(2, n1, replace = T, prob = c(0.7, 0.3))
table(ind3)

train2 = iris[ind3==1, ]
test2 = iris[ind3==2, ]



## 층화 임의 추출

# 남성 20%, 여성 80%로 구성된 집단이 있을 때 이 집단의 평균 키를 측정한다고
# 가정해보자. 성별에 따라 키의 차이가 명확히 존재할 것이므로 표본을 잘 추출하는 것이 무엇
# 보다 중요할 것이다. 그런데 단순 임의 추출을 적용하게되면 남성이 우연히 20%보다 더 많이
# 추출되거나 또는 20%보다 더 적게 추출될 수 있다. 다시 말해 단순 임의 추출은 평균에 대한
# 추정의 정확도가 떨어지는 위험이 있다.
# 이런 경우 층화 추출을 사용해 데이터로부터 남성과 여성의 표본의 갯수를 2:8로 유지하여
# 뽑는다면 더 정확한 결과를 얻을 수 있게된다.


#install.packages('sampling')
library(sampling)

x <- strata (c("Species"), size  = c(3, 3, 3) , method = "srswor", data = iris) 
# size = 그룹으로 나눌 레이블의 수. 각각 3개씩 Species 추출
# method = srswor(Simple Random Sampling Without Replacement. 비복원 단순 임의 추출)

xx <- strata (c("Species"), size  = c(3, 7, 51) , method = "srswr", data = iris) 
## 복원 추출 method = "srswr"

getdata(iris, x)

rep(1, 3)   # 1 숫자 반복
rep(1:3, 3) # 1부터 3까지 숫자 번갈아 반복

rep(c(3,7), 3)        # 1과 3 숫자 번갈아 반복
rep(c(3,7), c(3,2))   # 첫번째수 3번 두번째수 2번 반복
rep(c(3,7), each = 3) # 각각 3번씩 

rep(1:10, length.out=15) # 앞에서 부터 최대길이 5까지만 출력
                         # length.out이 rep의 최대값 보다 크다면 1부터 다시 시작.

A1 = iris


A1 $ Species2 <- rep (1:2 , 75)
strata (c("Species", "Species2"), size =c(1, 1, 1, 1, 1, 1) , method ="srswr", data = A1 )

## sampleBy 함수 -- 각 층마다 동일한 갯수의 표본 추출

library(doBy)
sampleBy(~Species + Species2, frac = 0.3, data=A1)


## 계통추출 -- 범위구간을 정해서 인덱스 번호 추출

# 아침부터 밤까지 특정한 지역을 지나간 차량의 번호를 모두 조사하였고, 이들로부터 조사 대
# 상을 뽑는 경우를 가정해보자. 가장 간단한 단순 임의 추출을 적용하여 차량 번호를 뽑는다면
# 우연히 아침시간에 지나간 차량을 더 많이 뽑거나 저녁시간에 지나간 차량을 더 많이 뽑는
# 편향이 발생할 수 있다. 계통추출은 이런 상황에서 해답이 될 수 있다.
# 계통 추출은 모집단의 임의 위치에서 시작해 매 k 번째 항목을 표본으로 추출하는 방법이
# 다. 예를들어 1, 2, 3, ..., 10까지의 수에서 3개의 샘플을 뽑는다고 가정해보자. 10/3 = 3.333...
# 이므로 k = 3이다. 표본 추출 시작위치를 잡기위해 1 ∼ k 사이의 수 하나를 뽑는다. 이 수가
# 2라하자. 나머지 두 수를 뽑기위해 2 + k 에 해당하는 5를 뽑는다. 다음, 5 + k에 해당하는 8을
# 뽑는다. 그러면 최종적으로 표본 ‘2, 5, 8’를 얻는다.



d1 = data.frame() ## 값을 받기(쌓이게 하기) 위해 데이터프레임 생성
for(i in seq(sample(1:10, 1), 150, 10)){
  d2 = iris[i, ]
  d1 = rbind(d1, d2) ## d1에 d2값이 누적이 되도록.
}

table (c("a", "b", "b", "b", "c", "c", "d")) # 몇번의 단어가 나왔는지 수 세기

d <- data.frame (x=c("1", "2", "2", "1"),
                 y=c("A", "B", "A", "B"),
                 num=c(3, 5, 8, 7))
d
d1 = rbind(d,d) # rowbind -- 아래 방향으로 붙이기

table(d1$x, d1$y) # x와 y가 몇번 나왔는지 수 세기
xt = xtabs(num ~ x+y, data=d1) # 위와 동일 

sum(xt)              # xt에 대한 sum
margin.table(xt, 2)  # xt에 대한 sum, 1,2 는 행 렬의 합을 나타냄.
prop.table(xt, 2)    # xt에 대한 확률, 1,2 는 행 렬의 확률의 합이 1

tot = sum(xt)
p_xt = prop.table(xt)

str(p_xt)

tot*p_xt[[1]][1]


### 독립성 검정 (다음에 적합도 검정도 해야 한다)

# 분할표의 행에 나열된 속성과 열에 나열된 속성이 독립이라면 (i, j) 셀의 확률 P(i, j)에 대해
# 다음 식이 성립한다.
# P(i, j) = P(i) × P(j)


 library ( MASS )
data ( survey )
str( survey )
View(survey)
xt = xtabs(~Sex+Exer, data=survey)

## 카이 스퀘어 테스트 진행 (카이 스퀘어 테스트는 독립성 검정이다.)

chi1 = chisq.test(xt)
chi1 
str(chi1) 

# p값이 0.05731이므로 0.05보다 커서 ‘H0: 성별과 운동은 독립이다’ 라는 귀무가설을 기각할
# 수 없는 것으로 나타났다. 통계량 χ2는 5.7184이었으며 자유도(Degree of Freedom)는 2였다.

chi1$statistic

xtabs (~W.Hnd + Clap , data = survey)
fisher.test(xtabs(~W.Hnd + Clap, data = survey))
chisq.test(xtabs (~W.Hnd + Clap, data = survey))

## 벌금을 부과하기 시작한 후 안전 벨트 착용자의 수, 유세를 하고난 뒤 지지율의 변화와 같이
# 응답자의 성향이 사건 전후에 어떻게 달라지는지를 알아보는 경우 맥니마 검정을 수행한다

### 적합도 검정

# 통계 분석에서는 종종 데이터가 특정 분포를 따름을 가정한다. 특히 데이터의 크기가 일정 수
# 이상이라면 데이터가 정규성을 따름을 별 의심없이 가정하기도 하지만 실제 검정을 해 볼 수도 있다.

# Chi Square Test (적합도 검정에도 사용된다)

table(survey $ W.Hnd)

chisq.test ( table ( survey $ W.Hnd ), p=c(.3 , .7)) # p : 확률, c(left, right)
# p-value < 0.05 이므로 글씨를 왼손으로 쓰는 사람과 오른손으로 쓰는 사람의 비가 30% : 70%이라는 
# 귀무 가설을 기각한다.
t1 = table ( survey $ W.Hnd )
str(t1)
t1[1]

t1 / sum(t1)


## Shapiro-Wilk Test
# Shapiro Wilk Test는 표본이 정규분포로 부터 추출된 것인지 테스트하기 위한 방법이다. 검정은
# shapiro.test() 함수를 사용하며 이 때 귀무가설은 주어진 데이터가 정규분포로부터의 표본이라는 것이다.
shapiro.test ( rnorm (1000) ) # p-value > 0.05 

## Kolmogorov-Smirnov Test
# K-S Test(Kolmogorov-Smirnov Test)는 비모수 검정(Nonparameteric Test)으로 경험적 분포
# 함수(Empirical Distribution Function)와 비교대상이 되는 분포의 누적분포함수(Cumulative
# Distribution Function)간의 최대 거리를 통계량으로 사용한다.

ks.test ( rnorm (100, 5, 3) , rnorm (100, 5, 3) ) # 두개의 셈플이 동일한지 아닌지.
                                                  # 귀무가설은 두 분포가 같다.

## Q-Q plot (회기분석시 활용)
# 자료가 특정 분포를 따르는지를 시각적으로 검토하기위해 Q-Q Plot을 사용한다. Q-Q Plot은
# Quantile-Quantile Plot의 약자로 비교하고자하는 [분포의 분위수끼리 좌표 평면]에 표시하여 그린다.

x <- rnorm (1000 , mean =10 , sd =1) # 정규분포 데이터
qqnorm (x)  # Plot 출력
qqline (x, lty =2) # Plot 위에 점선 오버랩.

x <- rcauchy (1000) # 정규분포가 아닌 데이터
qqnorm (x) # Plot 출력 --> 정규성을 따르지 않는다.
qqline (x, lty =2)


### 상관계수

# 상관계수는 두 확률 변수 사이의 관계를 파악하는 방식으로, 흔히 상관계수라고하면 피어슨 상관계수를 뜻한다.
# 상관 계수 값이 크면 데이터간의 연관 관계가 존재한다는 의미이다. 그러나 이것이 반드시
# 인과관계를 뜻하는 것은 아니다. A가 B를 야기한다고 판단했으나 실제로는 C5)가 B를 야기하고 있거나, 
# A가 B의 원인이라고 예상했지만 실제로는 B가 A의 원인일 수도 있기 때문이다.

## 피어슨 상관계수(Pearson Correlation Coefficient)

# 피어슨 상관계수는 선형 관계를 판단한다. 따라서 비선형 관계 
# (예를들어 Y = aX2 + b형태)에 대해서는 제대로 판별하지 못할 수 있다.)

cor( iris [ ,1:4])
symnum ( cor( iris [ ,1:4]) ) # B는 BEST의 약자로 가장 상관관계가 높다는 것을 의미한다.

# 상관계수 시각화 패키지
# install.packages ("corrgram")
library (corrgram)
corrgram ( cor( iris [ ,1:4]) , type ="corr", upper.panel = panel.conf )

## 스피어만 상관계수(Spearman’s [Rank] Correlation Coefficient)

# 야구에 많이 활용(연봉책정 등) 두 값의 순위를 사용
# 스피어만 상관계수는 상관계수를 계산할 두 데이터의 실제값 대신 두 값의 순위를 사용해
# 상관계수를 비교하는 방식이다. 계산 방법이 피어슨 상관계수와 유사해 이해가 쉽고, 피어슨
# 상관계수와 달리 비선형 관계의 연관성을 파악할 수 있다는 장점이 있다. 또한 순위만 매길
# 수 있다면 적용이 가능하므로 연속형(Continous) 데이터에 적합한 피어슨 상관계수와 달리
# 이산형(Discrete) 데이터, 순서형(Ordinal) 데이터에 적용이 가능하다.
# 예를들어 국어 점수와 영어 점수간의 상관계수는 피어슨 상관계수로 계산할 수 있고, 국어
# 성적 석차와 영어 성적 석차의 상관계수는 스피어만 상관계수로 계산 가능하다.

x <- c(3, 4, 5, 3, 2, 1, 7, 5) 

rank ( sort (x)) # 5, 5는 순위가 6, 7위 이므로 평균인 6.5가 순위로 주어진것

m <- matrix (c (1:10 , (1:10) ^2) , ncol =2)
m
library(Hmisc)
# m식의 피어슨, 스피어슨 상관계수 비교
rcorr (m, type ="pearson")$r
rcorr (m, type ="spearman")$r
# 보다시피 두 컬럼간 피어슨 상관계수는 0.97이었지만 스피어만 상관계수는 1.00으로 나타났다.
# 이 절의 시작에서 확률 변수간 독립이면 상관 계수가 0이지만 상관 계수가 0이라고해서
# 독립이지는 않음을 설명했다. 다음에 보인 코드에서는 Y = X2의 명확한 의존 관계가 있는 X,
# Y 간 상관계수가 0임을 보여준다.

# 켄달의 순위 상관 계수(Kendal’s Rank Correlation Coefficient)

# (X, Y) 형태의 순서쌍으로 데이터가 있을 때 xi < xj , yi < yj가
# 성립하면 concordant, xi < xj 이지만 yi > yj이면 discordant라고 정의한다.
# 세개의 차이점을 알아야 한다.

# install.packages ("Kendall")
library (Kendall)
Kendall (c(1, 2, 3, 4, 5) , c(1, 0, 3, 4, 5))

cor.test (c(1, 2, 3, 4, 5) , c(1, 0, 3, 4, 5) , method ="pearson")

## "성별 키의 값은 같다" 가설 검증

ss1 = survey[ survey $ Sex == 'Male', "Height" ]
ss3 = survey[ survey $ Sex == 'Female', "Height" ]
m1 = survey[ survey $ Sex == 'Male', ] 
f1 = survey[ survey $ Sex == 'Female', ] 

ss2 = na.omit(ss1) # 데이터 핸들링 -- NA 값 제거.
ss4 = na.omit(ss3)
mean(ss1) # NA가 있어서 평균 계산 안됨
mean(ss2)  # NA값 제거 --> 계산잘됨

t.test(x=ss2, mu=173.5) # 가설이 맞지 않다. p-value < 0.05
t.test(x=ss2, mu=178.5) # 가설이 맞다 p-value > 0.05

t.test(x=ss3, mu=167) # 가설이 맞다. p-value > 0.05

length(ss2);length(ss4)
var.test(x=ss2, y=ss4) # 2집단이 등분산인지 이분산인지 점검
                       # 귀무가설은 무조건 같다. (등분산)
                       # p-value < 0.05 귀무가설 기각

t.test(x=ss2, y=ss3, var.equal = F, paired = F)    # 귀무가설 채택 : val.equal = T
                                                   # 귀무가설 기각 : val.equal = F
                                                   #  x값, y값 동일 : paired = T             
# p-value < 0.05 귀무가설 기각. ==> '남녀간의 키가 동일' 가설을 기각

# "성별 심박수의 차이는 같다" 가설검증
# 사전에 'NA' DATA HANDLING --> 

pp1 = survey[ survey $ Sex == 'Male', "Pulse" ]
pp3 = survey[ survey $ Sex == 'Female', "Pulse" ]

pp2 = na.omit(pp1)
pp4 = na.omit(pp3)

t.test(x=pp2, y=pp4, var.equal = F, paired = F)  # "두 성별간의 심박수의 차이는 같다" 
                                                 # p > 0.05 귀무가설 채택


sleep

var.test(extra~group, data=sleep) # 등분산인지 이분산인지 검정
t.test(extra~group, data=sleep, var.equal = T, paired = T)
# paired = T 로 하면 첫번째 것이 첫번째 걸로, 두번째 것이 두번깨 걸로 순서에 맞춰서 채택
# paired = F 로 하면 독립적으로 시행
# p < 0.05 "두 집간단의 차이가 같다"는 가설을 기각

sleep1 = sleep[1:10, ]
sleep1$group2 = sleep[11:20, 1] # group2 로 컬럼 추가 후 데이터 붙임
t.test(x = sleep1$extra, y = sleep1$group2, data=sleep, var.equal = T, paired = T)
# 위의 것과 같은 결과. 

with(sleep , t.test ( extra [ group ==1] , extra [ group ==2] , paired = TRUE ))

# p-value < 0.05이므로 귀무가설 ‘H0: 모평균의 차이가 0 이다’를 기각한다. 따라서 두 수면제의 
# 수면시간 연장 정도가 다르다고 결론을 내린다.

### 기상청에서 '황사' 자료 엑셀파일로 읽어오기

library(xlsx)
s1 = read.xlsx('s1.xlsx', sheetIndex = 1, startRow = 2, header = T, encoding = 'UTF-8')
gg1 = read.table('clipboard', header = T) # table은 인코딩을 해주지 않아도 한글지원
gg2 = read.table('clipboard', header = T) # data hadling -- read.table시 엑셀파일에 빈 값이 없어야 함

## 새벽 1시부터 4시까지 황사 t.test

var.test(gg1$X01시, gg1$X04시) # 등분산/ 이분산 --> 같은지역의 황사 정도가 차이가 별로 없다.
t.test(x = gg1$X01시, y= gg1$X04시, var.equal = T, paired = F) 
# paired = F : 독립, 특정 지역에 구애 받지 않고 test (전국적으로)
t.test(x = gg1$X01시, y= gg1$X04시, var.equal = T, paired = T)
# paired = F : 독립, 특정 지역을 하나씩 비교하여 test (지역적으로) 
## 큰 차이가 있지는 않다. (새벽 1시부터 4시까지)


## 오전 6시부터 오후 6시까지 황사 t.test

var.test(gg2$X06시, gg2$X18시) # p = 0.01 --> 이분산
t.test(x = gg2$X06시, y= gg2$X18시, var.equal = F, paired = F) 
# paired = F : 독립, 특정 지역에 구애 받지 않고 test (전국적으로)
t.test(x = gg2$X06시, y= gg2$X18시, var.equal = F, paired = T) 
# paired = F : 독립, 특정 지역을 하나씩 비교하여 test (지역적으로) 
# paired = T : 지역으로 부터 올수있는 기본적인 오차 배제. 더 정확하다. BEFORE/AFTER
## p = 0.01 --> 차이가 있다! "시간에 따라 황사발생량이 같다"는 가설 기각
  
