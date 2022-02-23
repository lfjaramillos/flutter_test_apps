

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/article.dart';
import 'package:flutter_testing/news_change_notifier.dart';
import 'package:flutter_testing/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService{}

void main(){

  late NewsChangeNotifier ncn;
  late MockNewsService mockNewsService;



  setUp(()  {
    mockNewsService = MockNewsService();
    ncn  = NewsChangeNotifier(mockNewsService);
  });


  group('getArticles',(){

    final articlesFromService = [
      Article(title: "title 1", content: "content 1"),
      Article(title: "title 2", content: "content 2"),
      Article(title: "title 3", content: "content 3"),
    ];

    void arrangeNewsServiceReturn3Articles(){
      when(()=> mockNewsService.getArticles()).thenAnswer((invocation) async => articlesFromService );
    }
    test(
        "Initial values are correct",
            (){
          expect(ncn.articles,[]);
          expect(ncn.isLoading, false);
        }
    );

    test('gets articles using service', () async{
      arrangeNewsServiceReturn3Articles();
        await ncn.getArticles();
        //check get articles is called one time
        verify(()=> mockNewsService.getArticles()).called(1);
    },
    );
    test("""indicates loadinf of data,
    sets articles to the ones from the service,
    indicates that data is not being loaded anymore""", () async{
      arrangeNewsServiceReturn3Articles();
      final future =  ncn.getArticles();
      expect(ncn.isLoading, true);
      await future;
      expect(ncn.articles, articlesFromService);
      expect(ncn.isLoading, false);
    },
    );



}

  );
}