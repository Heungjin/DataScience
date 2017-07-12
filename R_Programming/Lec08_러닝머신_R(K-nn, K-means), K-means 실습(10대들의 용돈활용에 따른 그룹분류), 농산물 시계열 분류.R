#### Lecture 08. 러닝머신_R(K-nn, K-means), K-means 실습(10대들의 용돈활용에 따른 그룹분류), 농산물 시계열 분류 

wbcd = read.csv('wisc_bc_data.csv', header = T, stringsAsFactors = F, sep =',')
View(wbcd)
str(wbcd)

# 데이터 재편집
wbcd = wbcd[,-1] # wbcd에서 첫번째 컬럼 제거 
wbcd$diagnosis = factor(wbcd$diagnosis) # diagnosis 컬럼을 chr ==> Factor 형태로 변경

nlevels (wbcd$diagnosis)

# 단위에서 오는 문제로 인해 정규화(Normalization) 진행

wbcd_n = wbcd
wbcd_n[, -1] = scale(wbcd_n[,-1])
View(wbcd_n)

nn = nrow(wbcd_n) ## 데이터의 갯수
train = wbcd_n[1 : (nn * 0.7), ] # 1번부터 398번까지
test = wbcd_n[((nn * 0.7) + 1) : nn , ] # 398 + 1 번부터 끝(nn)까지

install.packages('class')
library(class)

### K-nn : 가장 가까운 이웃 알고리즘
# KNN 알고리즘의 개념에 대해 간단하게 보자면 새로운 데이터의 가장 가까운 
# 데이터들의 클래스(계급, 범주)를 따라 클래스를 정해주는 것.

# Y값을 이미 아는 상태 -- 분류기법
# 가장 가까운 그룹에서의 빈도가 높은 순으로 그룹이 편성됨
# k- 10일경우 (a그룹 5개 b 그룹 3개 c 그룹 2개)순으로 가까울 경우 a로 편성

out1 = data.frame() # 데이터를 받을 데이터프레임 구조의 변수 생성
for(i in 1 : 15){
pred1 = knn(train[, -1], test[, -1], train[, 1], k = i) # k = 3 가장 가까운 순으로 3개
                                                        # 몇개의 k가 가장 정확한 결과값을 보이는지 검정
t1 = table (test[,1], pred1)
cor1 = sum(diag(t1)) / sum(t1) 
out2 = cbind(i, cor1) 
out1 = rbind(out1, out2)
}
View(out1)
View(wbcd_n)

# i = 5 가 0.982로 가장 높다

# out3 = which.max(out1,[ ,2])
# out1[out3,]

1 - 1:10  # 1 - (1:10)

for(i in 1:10){
  c1 = 1 - i
  c = c (c,c1)
}

## Iris에 KNN 적용

# iris dataset 정규화 진행/ factor를 기준으로 잡아야 한다.
iris[, -5] = scale(iris[,-5])
# test데이터 샘플 구하기
iris
iris_row = nrow(iris) ## 데이터의 갯수
iris_train = iris[1 : (iris_row * 0.7), ] # 1번부터 398번까지
iris_test = iris[((iris_row * 0.7) + 1) : iris_row , ] # 398 + 1 번부터 끝(nn)까지
str(iris)
# iris 데이터셋으로 KNN 알고리즘 적용
iris_out1 = data.frame() # 데이터를 받을 데이터프레임 구조의 변수 생성
for(i in 1 : 15){
  iris_pred1 = knn(iris_train[, -5], iris_test[, -5], iris_train[, 5], k = i) # k = 3 가장 가까운 순으로 3개
  iris_t1 = table (iris_test[,5], iris_pred1)
  iris_cor1 = sum(diag(iris_t1)) / sum(iris_t1) 
  iris_out2 = cbind(i, iris_cor1) 
  iris_out1 = rbind(iris_out1, iris_out2)
}
iris_out1

# 0.7556이 가장 크므로 i = 1 에서 가장 정확하다.

### 거리 측정법

# hclust -- 계층적군집분석 (최단 연결법/최장 연결법)
# 어느정도의 군집이 나올 수 있는지 확인 할 수 있음 (군집 -- 그룹의 수)
# 각 데이터마다 얼마나 가깝게 있는지 거리 분석

a <- c(1,6)
b <- c(2,4)
c <- c(5,7)
d <- c(3,5)
e <- c(5,2)
f <- c(5,1)

c_data <- data.frame(a,b,c,d,e,f)

c_data <- t(c_data) # t는 trans를 의미. 행/렬 서로 맞바꾸기 

d = dist(c_data, method = 'euclidean')
# 각각에 대한 거리를 유클리드 방식으로 산출
h1 = hclust(d, method = 'single') # 계층적 군집분석
plot(h1) # 가까운 것 순(거리가 짧은 것 순)으로 계층이 묶임


## iris방식으로 k-means 적용
# k-means 
# 사전에 군집별 평균값을 지정해 놓고 새로운 데이터가 들어왔을때그 그룹의 평균값과 가장 유사한 
# 집단으로 편성 --> 다시 새로운 데이터들로 평균을 냄 (데이터의 군집이 바뀔수도 있다.)
# 이상치들은 어느 군집에도 속하지 않을 수 있음
# 군집간의 거리
# 비계층적 군집방법

# Y값을 모름 -- 군집의 평균을 구해서 최적의 모형으로 할당하여야 함
# k-nn과는 거리를 이용하여 가장 가까운 것을 찾아내는 점은 동일
# 차이점은 K-means는 Y값을 모른다는 것 

k1 = kmeans(iris[, 1:4], 3, iter.max = 1000) # iter.max가 높을수록 결과가 더 정확히 나온다
                                            # 오차가 없을때까지 결과가 나온다.
k1$cluster # 각각의 군집 할당
k1$withinss # 각각의 군집내의 오차  # 오차가 클수록 여러종류의 데이터가 섞여 있음
k1$tot.withinss # 각각의 군집내 오차의 합 7
table(iris$Species, k1$cluster)
clust1 = ifelse(k1$cluster == 2, 3, ifelse(k1$cluster == 3, 2, 1))
table(iris$Species, clust1)


k0 = data.frame()
for ( i in 1:6 ){
  k2 = kmeans( iris[ ,1:4], i, iter.max = 1000 ) 
  k3 = cbind( i, k2$tot.withinss )
  k0 = rbind(k0, k3)
}
plot(k0, type = 'b') #  type = 'p' -- point(점) 'l' -- line(선) 'b' -- both(둘다)
                     # plot을 보고 기울기가 완만해지는 시점에서 끊어서 k-means를 설정하여야 한다. 
                     # 따라서 k = 3이후 기울기가 완만해 지므로 3으로 설정한다.
k0[which.min(k0[, 2]), ]


# 거리 안에서 군집을 만든다음 가장 가까운 거리로 


### 십대들이 용돈을 어디에 쓰는지에 대한 데이터 

teens <- read.csv("snsdata.csv",header = T, sep = ',')
table(teens$gender, useNA = "ifany")
summary(teens$age)

teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA) # 중, 고등학생들 나이만
teens$female <- ifelse(teens$gender == "F" & !is.na(teens$gender), 1, 0)
teens$no_gender <- ifelse(is.na(teens$gender), 1, 0)
# 성별이 없는 데이터를 지우면 26%의 데이터를 지우는 것과 같기 때문에 최대한 
# 데이터를 쓰려고 제안. --> 남자가 아님, 여자가 아님 등

head(teens, 10)

mean(teens$age) # NA값 존재로 인해 결과가 NA로 나옴

ave_age <- ave(teens$age, teens$gradyear, FUN = function(x) mean(x, na.rm = T))

teens$age <- ifelse(is.na(teens$age), ave_age, teens$age) # 나이가 입력되지 않았을때 평균 값으로 넣어준다

table(teens$age, useNA = "ifany")
length(which(teens$age == NA)) # NA가 존재하지 않는다. (length = 0)
interests <- teens[5:40]
interests_z <- as.data.frame(lapply(interests, scale))

teen_clusters <- kmeans(interests_z, 5)
table(teen_clusters$cluster)

teen_clusters$centers # 결과를 보면 어떤 집단이 어떠한 특징을 보이는지 대략적으로 예측가능 
                      # 이름을 붙일 수 있게 됨 




### k-means가 아닌 다른 클러스트링 기법을 이용한 농산물 데이터분석

library3 <- c("plyr", "TSclust", "zoo", "ggplot2" ) 
unlist(lapply(library3, require, character.only = TRUE ))

# 지역별 돼지고기 가격에 대한 데이터
pig.region <- read.csv("Data/pig.region.csv", header=T, fileEncoding="UTF-8")[,-1]
head(pig.region, n=10)

# 월간 평균 돼지고기 소매가격에 대한 데이터
pig.region.monthly.mean <- read.csv("Data/pig.region.monthly.mean.csv", header=T, fileEncoding="UTF-8")[,-1] 
head(pig.region.monthly.mean, n=10)

# 일간 품목별 평균 데이터
date.item.mean <- read.csv("Data/date.item.mean.csv", header=T, fileEncoding="UTF-8")[,-1] 
head(date.item.mean, n=10)

# 월간 품목별 평균 데이터
month.item.mean <- read.csv("Data/month.item.mean.csv", header=T, fileEncoding="UTF-8")[,-1] 
head(month.item.mean)

library(plyr)
temp <- dlply(date.item.mean, .(name), summarise, mean.price) 

## 축산물을 제외하도록 데이터 핸들링
farm.product <- data.frame(쌀=unlist(temp$쌀), 
                            배추=unlist(temp$배추), 
                            상추=unlist(temp$상추), 
                            호박=unlist(temp$호박),
                            양파=unlist(temp$양파),
                            파프리카=unlist(temp$파프리카), 
                            참깨=unlist(temp$참깨), 
                            사과=unlist(temp$사과)) 
head(farm.product, n=10)
cor(temp$닭고기, temp$돼지고기) # 두개씩 묶어야 결과가 출력
cor(farm.product)               # 메트릭스 구조로 바꾸면 모두 출력

# dlply() : 데이터 프레임 형태를 품목이름별로 list 형태로 출력함
# – unlist() : list형태를 vector형태로 변환함
# – data.frame : vector형태의 데이터를 data frame 형태로 변환함

library(TSclust)

# 품목별 hclust 
plot(hclust(diss(farm.product,"COR"))) # COR의 거리를 구한다
                                       # cor - 상관관계를 의미 
                                       # cor이 높을수록 거리가 가깝다고 가정/ 낮을수록 멀다고 가정

methods(plot) # plot의 종류를 볼 수 있는 명령어
              # help에 plot.hclust 검색 --> 문법들을 알 수 있다.


## 시계열 분석 (시간의 변화에 따른 데이터의 변동)
month.item.mean$month <- as.Date(as.yearmon(month.item.mean$month, "%Y-%m"))

# 상관관계가 높은 상추-호박의 데이터 시계열 변동
ggplot(month.item.mean[month.item.mean$name %in% c("상추", "호박"),], aes(x=month, y=mean.price, colour=name, group=name)) + geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) + ylab("가격") + xlab("")

# 지역별 hclust
plot(hclust(diss(pig.region,"COR")), axes = F, ann = F) # 가까운 도시 위주로 묶여 있다.
                                                        # 가까운 도시의 돼지고기 가격이 유사
# diss(farm.product,"COR") : 데이터 프레임 형태의 farm.product를 correlation 방법으로 계산함
# – hclust() : 계산된 오브젝트를 군집화함
# – plot() : 군집된 결과를 그림으로 나타냄
# – axes = F : 모든 축을 출력하지 않도록 설정함
# – ann = F : 모든 축에 대한 설명을 출력하지 않도록 설정함


# 상관관계가 높은 광주-대구의 돼지고기 가격 시계열 변동
ggplot(pig.region.monthly.mean[pig.region.monthly.mean$region %in% c(2200,2401),], aes(x=month, y=mean.price, colour=name, group=name)) + geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) + ylab("돼지고기 가격") + xlab("")

# 상관관계가 높은 부산-울산의 돼지고기 가격 시계열 변동
ggplot(pig.region.monthly.mean[pig.region.monthly.mean$region %in% c(2100,2601),], aes(x=month, y=mean.price, colour=name, group=name)) + geom_line() + theme_bw() + geom_point(size=6, shape=20, alpha=0.5) + ylab("돼지고기 가격") + xlab("")



### 날씨 자료와 농산물 자료의 인과관계 분석

library4 <- c("plyr", "stringr","dygraphs", "zoo", "xts") 
unlist(lapply(library4, require, character.only = TRUE ))

product <- read.csv("Data/product.csv", header=T, fileEncoding="UTF-8") 
weather <- read.csv("Data/weather.csv", header=T, fileEncoding="UTF-8") 
code <- read.csv("Data/code.csv", header=T, fileEncoding="UTF-8")

subset(code, 구분코드설명 %in% c("지역코드"))
# subset() : 전체 데이터에서 특정 조건을 만족하는 값을 출력함
# – %in% : 조건에 대해 일치여부를 boolean 형으로 출력하는 기능의 연산자임

category <- subset(code, code$구분코드설명=="품목코드") 
category
colnames(product) <- c('date','category','item','region','mart','price') 
colnames(category) <- c('code', 'exp', 'item', 'name')

seoul.item <- merge(ddply(product[which(product$region==1101),], .(item, date), summarise, mean.price=mean(price)), category, by="item", all=T)
head(seoul.item, n=10)

#### 농산물 보고서에 대한 결론
# 보고서로서는 좋지 않다.
# 보고서의 목표가 빈약하다. --> 명확한 목표 설정
# 보고서에 결과가 없다. --> 명확한 결과, 결론 
# 다만 데이터 핸들링과정은 잘 된 보고서.
