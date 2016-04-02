module TagsHelper

  # create tags and return array of invalid tag's name for error message
  def register_tags(lesson, tag_str)
    sanitize_tag(tag_str)
      .map { |tag| @lesson.tags.create(name: tag)}
      .select { |record| !record.valid? }
      .map { |record| record.name }
  end

  private
    def sanitize_tag(tag_str)
      tag_str.split(',').map { |tag| tag.strip }
    end
end
