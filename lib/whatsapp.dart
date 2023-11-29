import 'package:flutter/material.dart';
import 'package:storyexample/repository.dart';
import 'package:story_view/story_view.dart';
import 'package:storyexample/util.dart';
import 'package:storyexample/widgets.dart';

class Whatsapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<WhatsappStory>>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.removeAt(0);
            snapshot.data!.removeAt(0);
            snapshot.data!.removeAt(0);
            snapshot.data!.removeAt(1);
            snapshot.data!.removeAt(2);
            snapshot.data!.removeAt(3);
            snapshot.data!.removeAt(0);
            snapshot.data!.removeAt(0);
            snapshot.data!.removeAt(0);
            snapshot.data!.add(
              WhatsappStory(
                mediaType: MediaType.lottie,
                media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_intro_personal.json",
                caption: "One.json",
                duration: 8,
                when: "2 hours ago",
                color: "#000000",
              )
            );
            snapshot.data!.add(
                WhatsappStory(
                  mediaType: MediaType.lottie,
                  media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_deposits_group.json",
                  caption: "Two.json",
                  duration: 5,
                  when: "2 hours ago",
                  color: "#000000",
                )
            );
            snapshot.data!.add(
                WhatsappStory(
                  mediaType: MediaType.lottie,
                  media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_projected_growth_personal.json",
                  caption: "Three.json",
                  duration: 5,
                  when: "2 hours ago",
                  color: "#000000",
                )
            );
            snapshot.data!.add(
                WhatsappStory(
                  mediaType: MediaType.lottie,
                  media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_growth_group.json",
                  caption: "Scene01.json",
                  duration: 5,
                  when: "2 hours ago",
                  color: "#000000",
                )
            );
            snapshot.data!.add(
                WhatsappStory(
                  mediaType: MediaType.lottie,
                  media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_growth_personal.json",
                  caption: "Scene02.json",
                  duration: 5,
                  when: "2 hours ago",
                  color: "#000000",
                )
            );
            //
            snapshot.data!.add(
                WhatsappStory(
                  mediaType: MediaType.lottie,
                  media: "https://multi-uploads.s3.af-south-1.amazonaws.com/franc/test/Conditional/na_goals_group.json",
                  caption: "Scene02.json",
                  duration: 5,
                  when: "2 hours ago",
                  color: "#000000",
                )
            );
            return StoryViewDelegate(
              stories: snapshot.data,
            );
          }

          if (snapshot.hasError) {
            return ErrorView();
          }

          return Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        },
        future: Repository.getWhatsappStories(),
      ),
    );
  }
}

class StoryViewDelegate extends StatefulWidget {
  final List<WhatsappStory>? stories;

  StoryViewDelegate({this.stories});

  @override
  _StoryViewDelegateState createState() => _StoryViewDelegateState();
}

class _StoryViewDelegateState extends State<StoryViewDelegate> {
  final StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  String? when = "";

  @override
  void initState() {
    super.initState();
    widget.stories!.forEach((story) {
      if (story.mediaType == MediaType.text) {
        storyItems.add(
          StoryItem.text(
            title: story.caption!,
            backgroundColor: HexColor(story.color!),
            duration: Duration(
              milliseconds: (story.duration! * 1000).toInt(),
            ),
          ),
        );
      }

      if (story.mediaType == MediaType.image) {
        storyItems.add(StoryItem.pageImage(
          url: story.media!,
          controller: controller,
          caption: story.caption,
          duration: Duration(
            milliseconds: (story.duration! * 1000).toInt(),
          ),
        ));
      }

      if (story.mediaType == MediaType.video) {
        storyItems.add(
          StoryItem.pageVideo(
            story.media!,
            controller: controller,
            duration: Duration(milliseconds: (story.duration! * 1000).toInt()),
            caption: story.caption,
          ),
        );
      }
      if (story.mediaType == MediaType.lottie) {
        storyItems.add(StoryItem.pageLottie(
          story.media!,
          controller: controller,
          duration: Duration(milliseconds: (story.duration! * 1000).toInt()),
          caption: story.caption
        ));
      }
    });

    when = widget.stories![0].when;
  }

  Widget _buildProfileView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                when!,
                style: TextStyle(
                  color: Colors.white38,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        StoryView(
          storyItems: storyItems,
          controller: controller,
          onComplete: () {
            Navigator.of(context).pop();
          },
          onVerticalSwipeComplete: (v) {
            if (v == Direction.down) {
              Navigator.pop(context);
            }
          },
          onStoryShow: (storyItem) {
            int pos = storyItems.indexOf(storyItem);

            // the reason for doing setState only after the first
            // position is becuase by the first iteration, the layout
            // hasn't been laid yet, thus raising some exception
            // (each child need to be laid exactly once)
            if (pos > 0) {
              setState(() {
                when = widget.stories![pos].when;
              });
            }
          },
        ),
        Container(
          padding: EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
          ),
          child: _buildProfileView(),
        )
      ],
    );
  }
}
